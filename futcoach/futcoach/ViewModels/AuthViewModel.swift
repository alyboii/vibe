//
//  AuthViewModel.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 5.01.2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false
    
    private let authRepository = AuthRepository()
    private let userRepository = UserRepository()
    
    init() {
        Task {
            await checkAuthenticationStatus()
        }
    }
    
    // Check if user is already signed in
    func checkAuthenticationStatus() async {
        currentUser = await authRepository.getCurrentUser()
        isAuthenticated = currentUser != nil
    }
    
    // Sign in
    func signIn(email: String, password: String) async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter email and password"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await authRepository.signIn(email: email, password: password)
            currentUser = user
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
            isAuthenticated = false
        }
        
        isLoading = false
    }
    
    // Sign up
    func signUp(email: String, password: String, fullName: String) async {
        guard !email.isEmpty, !password.isEmpty, !fullName.isEmpty else {
            errorMessage = "Please fill in all fields"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await authRepository.signUp(email: email, password: password, fullName: fullName)
            currentUser = user
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
            isAuthenticated = false
        }
        
        isLoading = false
    }
    
    // Sign out
    func signOut() async {
        isLoading = true
        
        do {
            try await authRepository.signOut()
            currentUser = nil
            isAuthenticated = false
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // Update user role
    func updateRole(_ role: UserRole) async {
        guard let userId = currentUser?.id else {
            errorMessage = "No user found"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await userRepository.updateUserRole(userId: userId, role: role)
            
            // Update local user object
            if var updatedUser = currentUser {
                updatedUser.role = role
                currentUser = updatedUser
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // Clear error
    func clearError() {
        errorMessage = nil
    }
}
