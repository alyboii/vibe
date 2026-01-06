//
//  UserRepository.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 5.01.2026.
//

import Foundation
import FirebaseFirestore

enum FirestoreError: LocalizedError {
    case documentNotFound
    case invalidData
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .documentNotFound:
            return "Document not found"
        case .invalidData:
            return "Invalid data format"
        case .unknown(let message):
            return message
        }
    }
}

class UserRepository {
    private let db = FirebaseService.shared.firestore
    private let usersCollection = "users"
    
    // Create user document
    func createUser(_ user: User) async throws {
        guard let userId = user.id else {
            throw FirestoreError.invalidData
        }
        
        let docRef = db.collection(usersCollection).document(userId)
        try await docRef.setData(user.toDictionary())
    }
    
    // Get user by ID
    func getUser(id: String) async throws -> User? {
        let docRef = db.collection(usersCollection).document(id)
        let document = try await docRef.getDocument()
        
        return User.fromFirestore(document)
    }
    
    // Update user role
    func updateUserRole(userId: String, role: UserRole) async throws {
        let docRef = db.collection(usersCollection).document(userId)
        try await docRef.updateData(["role": role.rawValue])
    }
    
    // Get all players (for coaches)
    func getAllPlayers() async throws -> [User] {
        let querySnapshot = try await db.collection(usersCollection)
            .whereField("role", isEqualTo: UserRole.player.rawValue)
            .getDocuments()
        
        return querySnapshot.documents.compactMap { User.fromFirestore($0) }
    }
    
    // Update user profile
    func updateUser(_ user: User) async throws {
        guard let userId = user.id else {
            throw FirestoreError.invalidData
        }
        
        let docRef = db.collection(usersCollection).document(userId)
        try await docRef.setData(user.toDictionary(), merge: true)
    }
}
