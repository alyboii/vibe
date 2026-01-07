//
//  AssignmentService.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 7.01.2026.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

@MainActor
class AssignmentService: ObservableObject {
    static let shared = AssignmentService()
    
    private let db = Firestore.firestore()
    
    @Published var assignments: [Assignment] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private init() {}
    
    // MARK: - Coach Methods
    
    /// Create a new assignment for player(s)
    func createAssignment(
        teamId: String,
        playerId: String?,
        drill: Drill,
        target: AssignmentTarget,
        dueDate: Date,
        notes: String? = nil
    ) async throws -> Assignment {
        guard let coachId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "AssignmentService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Lütfen giriş yapın"])
        }
        
        isLoading = true
        defer { isLoading = false }
        
        let assignment = Assignment(
            coachId: coachId,
            teamId: teamId,
            playerId: playerId,
            drillId: drill.id!,
            drillName: drill.name,
            drillCategory: drill.category,
            target: target,
            dueDate: dueDate,
            createdAt: Date(),
            status: .pending,
            notes: notes
        )
        
        let docRef = try await db.collection("assignments").addDocument(data: assignment.toDictionary())
        
        var createdAssignment = assignment
        createdAssignment.id = docRef.documentID
        
        assignments.insert(createdAssignment, at: 0)
        return createdAssignment
    }
    
    /// Create assignment for all team members
    func createTeamAssignment(
        teamId: String,
        drill: Drill,
        target: AssignmentTarget,
        dueDate: Date,
        notes: String? = nil
    ) async throws -> [Assignment] {
        guard let coachId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "AssignmentService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Lütfen giriş yapın"])
        }
        
        isLoading = true
        defer { isLoading = false }
        
        // Get all active team members
        let membersSnapshot = try await db.collection("team_members")
            .whereField("team_id", isEqualTo: teamId)
            .whereField("status", isEqualTo: MemberStatus.active.rawValue)
            .getDocuments()
        
        let playerIds = membersSnapshot.documents.compactMap { $0.data()["player_id"] as? String }
        
        var createdAssignments: [Assignment] = []
        
        for playerId in playerIds {
            let assignment = Assignment(
                coachId: coachId,
                teamId: teamId,
                playerId: playerId,
                drillId: drill.id!,
                drillName: drill.name,
                drillCategory: drill.category,
                target: target,
                dueDate: dueDate,
                createdAt: Date(),
                status: .pending,
                notes: notes
            )
            
            let docRef = try await db.collection("assignments").addDocument(data: assignment.toDictionary())
            var created = assignment
            created.id = docRef.documentID
            createdAssignments.append(created)
        }
        
        assignments.insert(contentsOf: createdAssignments, at: 0)
        return createdAssignments
    }
    
    /// Get assignments created by coach
    func getCoachAssignments(teamId: String? = nil) async throws -> [Assignment] {
        guard let coachId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "AssignmentService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Lütfen giriş yapın"])
        }
        
        isLoading = true
        defer { isLoading = false }
        
        var query: Query = db.collection("assignments")
            .whereField("coach_id", isEqualTo: coachId)
            .order(by: "created_at", descending: true)
        
        if let teamId = teamId {
            query = query.whereField("team_id", isEqualTo: teamId)
        }
        
        let snapshot = try await query.limit(to: 100).getDocuments()
        assignments = snapshot.documents.compactMap { Assignment.fromFirestore($0) }
        
        // Update overdue status
        updateOverdueStatus()
        
        return assignments
    }
    
    /// Cancel an assignment
    func cancelAssignment(assignmentId: String) async throws {
        try await db.collection("assignments").document(assignmentId).updateData([
            "status": AssignmentStatus.cancelled.rawValue
        ])
        
        if let index = assignments.firstIndex(where: { $0.id == assignmentId }) {
            assignments[index].status = .cancelled
        }
    }
    
    // MARK: - Player Methods
    
    /// Get assignments for current player
    func getPlayerAssignments(includePast: Bool = false) async throws -> [Assignment] {
        guard let playerId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "AssignmentService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Lütfen giriş yapın"])
        }
        
        isLoading = true
        defer { isLoading = false }
        
        var query: Query = db.collection("assignments")
            .whereField("player_id", isEqualTo: playerId)
            .order(by: "due_date", descending: false)
        
        if !includePast {
            query = query.whereField("status", in: [
                AssignmentStatus.pending.rawValue,
                AssignmentStatus.inProgress.rawValue
            ])
        }
        
        let snapshot = try await query.limit(to: 50).getDocuments()
        assignments = snapshot.documents.compactMap { Assignment.fromFirestore($0) }
        
        // Update overdue status
        updateOverdueStatus()
        
        return assignments
    }
    
    /// Get today's assignments
    func getTodayAssignments() async throws -> [Assignment] {
        let allAssignments = try await getPlayerAssignments()
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        return allAssignments.filter { assignment in
            let dueDay = calendar.startOfDay(for: assignment.dueDate)
            return dueDay <= tomorrow && assignment.status != .completed && assignment.status != .cancelled
        }
    }
    
    /// Start an assignment (mark as in progress)
    func startAssignment(assignmentId: String) async throws {
        try await db.collection("assignments").document(assignmentId).updateData([
            "status": AssignmentStatus.inProgress.rawValue
        ])
        
        if let index = assignments.firstIndex(where: { $0.id == assignmentId }) {
            assignments[index].status = .inProgress
        }
    }
    
    /// Complete an assignment
    func completeAssignment(assignmentId: String) async throws {
        try await db.collection("assignments").document(assignmentId).updateData([
            "status": AssignmentStatus.completed.rawValue,
            "completed_at": Timestamp(date: Date())
        ])
        
        if let index = assignments.firstIndex(where: { $0.id == assignmentId }) {
            assignments[index].status = .completed
            assignments[index].completedAt = Date()
        }
    }
    
    // MARK: - Statistics
    
    /// Get player's assignment completion stats
    func getPlayerStats(playerId: String) async throws -> AssignmentStats {
        let snapshot = try await db.collection("assignments")
            .whereField("player_id", isEqualTo: playerId)
            .getDocuments()
        
        let all = snapshot.documents.compactMap { Assignment.fromFirestore($0) }
        
        let completed = all.filter { $0.status == .completed }
        let pending = all.filter { $0.status == .pending || $0.status == .inProgress }
        let overdue = all.filter { $0.isOverdue }
        
        return AssignmentStats(
            totalAssigned: all.count,
            completed: completed.count,
            pending: pending.count,
            overdue: overdue.count,
            completionRate: all.isEmpty ? 0 : Double(completed.count) / Double(all.count) * 100
        )
    }
    
    // MARK: - Private Helpers
    
    private func updateOverdueStatus() {
        for i in assignments.indices {
            if assignments[i].isOverdue && assignments[i].status == .pending {
                assignments[i].status = .overdue
            }
        }
    }
}

// MARK: - Supporting Types

struct AssignmentStats {
    let totalAssigned: Int
    let completed: Int
    let pending: Int
    let overdue: Int
    let completionRate: Double
}
