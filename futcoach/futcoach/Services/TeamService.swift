//
//  TeamService.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 7.01.2026.
//

import Foundation
import Combine
import UIKit
import FirebaseFirestore
import FirebaseAuth

enum TeamServiceError: LocalizedError {
    case notAuthenticated
    case teamNotFound
    case invalidCode
    case codeExpired
    case alreadyMember
    case rateLimitExceeded
    case coachNotFound
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "Lütfen giriş yapın"
        case .teamNotFound:
            return "Takım bulunamadı"
        case .invalidCode:
            return "Geçersiz takım kodu"
        case .codeExpired:
            return "Takım kodu süresi dolmuş"
        case .alreadyMember:
            return "Zaten bu takımın üyesisiniz"
        case .rateLimitExceeded:
            return "Çok fazla deneme yaptınız. 10 dakika bekleyin."
        case .coachNotFound:
            return "Koç bilgisi bulunamadı"
        case .unknown(let message):
            return message
        }
    }
}

@MainActor
class TeamService: ObservableObject {
    static let shared = TeamService()
    
    private let db = Firestore.firestore()
    private let maxJoinAttempts = 5
    private let rateLimitWindowMinutes = 10
    
    @Published var currentTeam: Team?
    @Published var teamMembers: [TeamMember] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private init() {}
    
    // MARK: - Coach Methods
    
    /// Create a new team with unique 4-digit code
    func createTeam(name: String) async throws -> Team {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw TeamServiceError.notAuthenticated
        }
        
        isLoading = true
        defer { isLoading = false }
        
        // Generate unique code
        var teamCode = Team.generateCode()
        var attempts = 0
        
        while attempts < 10 {
            let exists = try await checkCodeExists(teamCode)
            if !exists { break }
            teamCode = Team.generateCode()
            attempts += 1
        }
        
        let team = Team(
            coachId: userId,
            name: name,
            teamCode: teamCode,
            codeRotatedAt: Date(),
            createdAt: Date(),
            memberCount: 0,
            isActive: true
        )
        
        let docRef = try await db.collection("teams").addDocument(data: team.toDictionary())
        
        var createdTeam = team
        createdTeam.id = docRef.documentID
        
        self.currentTeam = createdTeam
        return createdTeam
    }
    
    /// Rotate team code (generate new code, invalidate old)
    func rotateTeamCode(teamId: String) async throws -> String {
        guard Auth.auth().currentUser != nil else {
            throw TeamServiceError.notAuthenticated
        }
        
        isLoading = true
        defer { isLoading = false }
        
        // Generate unique new code
        var newCode = Team.generateCode()
        var attempts = 0
        
        while attempts < 10 {
            let exists = try await checkCodeExists(newCode)
            if !exists { break }
            newCode = Team.generateCode()
            attempts += 1
        }
        
        try await db.collection("teams").document(teamId).updateData([
            "team_code": newCode,
            "code_rotated_at": Timestamp(date: Date())
        ])
        
        if currentTeam?.id == teamId {
            currentTeam?.teamCode = newCode
            currentTeam?.codeRotatedAt = Date()
        }
        
        return newCode
    }
    
    /// Get coach's teams
    func getCoachTeams() async throws -> [Team] {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw TeamServiceError.notAuthenticated
        }
        
        let snapshot = try await db.collection("teams")
            .whereField("coach_id", isEqualTo: userId)
            .whereField("is_active", isEqualTo: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { Team.fromFirestore($0) }
    }
    
    /// Get team members
    func getTeamMembers(teamId: String) async throws -> [TeamMember] {
        let snapshot = try await db.collection("team_members")
            .whereField("team_id", isEqualTo: teamId)
            .whereField("status", isEqualTo: MemberStatus.active.rawValue)
            .order(by: "joined_at", descending: true)
            .getDocuments()
        
        let members = snapshot.documents.compactMap { TeamMember.fromFirestore($0) }
        self.teamMembers = members
        return members
    }
    
    /// Remove player from team
    func removePlayer(teamId: String, playerId: String) async throws {
        let memberId = TeamMember.documentId(teamId: teamId, playerId: playerId)
        
        try await db.collection("team_members").document(memberId).updateData([
            "status": MemberStatus.removed.rawValue
        ])
        
        // Update user's teamId
        try await db.collection("users").document(playerId).updateData([
            "team_id": FieldValue.delete()
        ])
        
        // Decrement member count
        try await db.collection("teams").document(teamId).updateData([
            "member_count": FieldValue.increment(Int64(-1))
        ])
        
        teamMembers.removeAll { $0.playerId == playerId }
    }
    
    // MARK: - Player Methods
    
    /// Join team with 4-digit code
    func joinTeam(code: String) async throws -> Team {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw TeamServiceError.notAuthenticated
        }
        
        isLoading = true
        defer { isLoading = false }
        
        // Rate limit check
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? userId
        try await checkRateLimit(deviceId: deviceId)
        
        // Find team by code
        let snapshot = try await db.collection("teams")
            .whereField("team_code", isEqualTo: code)
            .whereField("is_active", isEqualTo: true)
            .limit(to: 1)
            .getDocuments()
        
        guard let teamDoc = snapshot.documents.first,
              let team = Team.fromFirestore(teamDoc) else {
            // Log failed attempt
            try await logJoinAttempt(deviceId: deviceId, code: code, success: false)
            throw TeamServiceError.invalidCode
        }
        
        // Check if already a member
        let memberId = TeamMember.documentId(teamId: team.id!, playerId: userId)
        let existingMember = try await db.collection("team_members").document(memberId).getDocument()
        
        if existingMember.exists {
            throw TeamServiceError.alreadyMember
        }
        
        // Get current user info for denormalization
        let userDoc = try await db.collection("users").document(userId).getDocument()
        guard let user = User.fromFirestore(userDoc) else {
            throw TeamServiceError.unknown("Kullanıcı bilgisi alınamadı")
        }
        
        // Create team member
        let member = TeamMember(
            teamId: team.id!,
            playerId: userId,
            playerName: user.fullName,
            playerEmail: user.email,
            joinedAt: Date(),
            status: .active,
            invitedBy: team.coachId
        )
        
        try await db.collection("team_members").document(memberId).setData(member.toDictionary())
        
        // Update user's teamId
        try await db.collection("users").document(userId).updateData([
            "team_id": team.id!
        ])
        
        // Increment member count
        try await db.collection("teams").document(team.id!).updateData([
            "member_count": FieldValue.increment(Int64(1))
        ])
        
        // Log successful attempt
        try await logJoinAttempt(deviceId: deviceId, code: code, success: true)
        
        self.currentTeam = team
        return team
    }
    
    /// Get player's current team
    func getPlayerTeam() async throws -> Team? {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw TeamServiceError.notAuthenticated
        }
        
        let userDoc = try await db.collection("users").document(userId).getDocument()
        guard let user = User.fromFirestore(userDoc),
              let teamId = user.teamId else {
            return nil
        }
        
        let teamDoc = try await db.collection("teams").document(teamId).getDocument()
        guard let team = Team.fromFirestore(teamDoc) else {
            return nil
        }
        
        self.currentTeam = team
        return team
    }
    
    /// Leave current team
    func leaveTeam() async throws {
        guard let userId = Auth.auth().currentUser?.uid,
              let teamId = currentTeam?.id else {
            throw TeamServiceError.notAuthenticated
        }
        
        let memberId = TeamMember.documentId(teamId: teamId, playerId: userId)
        
        try await db.collection("team_members").document(memberId).updateData([
            "status": MemberStatus.inactive.rawValue
        ])
        
        try await db.collection("users").document(userId).updateData([
            "team_id": FieldValue.delete()
        ])
        
        try await db.collection("teams").document(teamId).updateData([
            "member_count": FieldValue.increment(Int64(-1))
        ])
        
        self.currentTeam = nil
    }
    
    // MARK: - Private Helpers
    
    private func checkCodeExists(_ code: String) async throws -> Bool {
        let snapshot = try await db.collection("teams")
            .whereField("team_code", isEqualTo: code)
            .whereField("is_active", isEqualTo: true)
            .limit(to: 1)
            .getDocuments()
        
        return !snapshot.documents.isEmpty
    }
    
    private func checkRateLimit(deviceId: String) async throws {
        let cutoff = Calendar.current.date(byAdding: .minute, value: -rateLimitWindowMinutes, to: Date())!
        
        let snapshot = try await db.collection("join_attempts")
            .whereField("device_id", isEqualTo: deviceId)
            .whereField("timestamp", isGreaterThan: Timestamp(date: cutoff))
            .whereField("success", isEqualTo: false)
            .getDocuments()
        
        if snapshot.documents.count >= maxJoinAttempts {
            throw TeamServiceError.rateLimitExceeded
        }
    }
    
    private func logJoinAttempt(deviceId: String, code: String, success: Bool) async throws {
        let attempt: [String: Any] = [
            "device_id": deviceId,
            "attempted_code": code,
            "timestamp": Timestamp(date: Date()),
            "success": success
        ]
        
        try await db.collection("join_attempts").addDocument(data: attempt)
    }
}
