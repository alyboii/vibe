//
//  AuthRepository.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 5.01.2026.
//

import Foundation
import FirebaseAuth

enum AuthError: LocalizedError {
    case invalidCredentials
    case userNotFound
    case emailAlreadyInUse
    case weakPassword
    case networkError
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .userNotFound:
            return "No account found with this email"
        case .emailAlreadyInUse:
            return "This email is already registered"
        case .weakPassword:
            return "Password must be at least 6 characters"
        case .networkError:
            return "Network error. Please check your connection"
        case .unknown(let message):
            return message
        }
    }
}

class AuthRepository {
    private let auth = FirebaseService.shared.auth
    private let userRepository = UserRepository()
    
    // Sign in with email and password
    func signIn(email: String, password: String) async throws -> User {
        do {
            let authResult = try await auth.signIn(withEmail: email, password: password)
            
            // Fetch user from Firestore
            if let user = try await userRepository.getUser(id: authResult.user.uid) {
                return user
            } else {
                throw AuthError.userNotFound
            }
        } catch let error as NSError {
            throw mapFirebaseError(error)
        }
    }
    
    // Sign up with email, password, and full name
    func signUp(email: String, password: String, fullName: String) async throws -> User {
        do {
            let authResult = try await auth.createUser(withEmail: email, password: password)
            
            // Create user document in Firestore
            let user = User(
                id: authResult.user.uid,
                email: email,
                fullName: fullName,
                role: nil // Role will be set later
            )
            
            try await userRepository.createUser(user)
            
            return user
        } catch let error as NSError {
            throw mapFirebaseError(error)
        }
    }
    
    // Sign out
    func signOut() async throws {
        try auth.signOut()
    }
    
    // Get current user
    func getCurrentUser() async -> User? {
        guard let firebaseUser = auth.currentUser else {
            return nil
        }
        
        return try? await userRepository.getUser(id: firebaseUser.uid)
    }
    
    // Get current user ID
    var currentUserId: String? {
        return auth.currentUser?.uid
    }
    
    // Map Firebase errors to AuthError
    private func mapFirebaseError(_ error: NSError) -> AuthError {
        guard let errorCode = AuthErrorCode(rawValue: error.code) else {
            return .unknown(error.localizedDescription)
        }
        
        switch errorCode {
        case .wrongPassword, .invalidEmail:
            return .invalidCredentials
        case .userNotFound:
            return .userNotFound
        case .emailAlreadyInUse:
            return .emailAlreadyInUse
        case .weakPassword:
            return .weakPassword
        case .networkError:
            return .networkError
        default:
            return .unknown(error.localizedDescription)
        }
    }
}
