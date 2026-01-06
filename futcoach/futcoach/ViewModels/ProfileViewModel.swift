//
//  ProfileViewModel.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 5.01.2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let authRepository = AuthRepository()
    private let userRepository = UserRepository()
    
    init() {
        Task {
            await loadUserProfile()
        }
    }
    
    func loadUserProfile() async {
        isLoading = true
        user = await authRepository.getCurrentUser()
        isLoading = false
    }
    
    func signOut() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await authRepository.signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func getUserInitials() -> String {
        guard let fullName = user?.fullName else { return "?" }
        let components = fullName.components(separatedBy: " ")
        let initials = components.compactMap { $0.first }.prefix(2)
        return String(initials).uppercased()
    }
    
    func formatJoinDate() -> String {
        guard let createdAt = user?.createdAt else { return "Unknown" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: createdAt)
    }
}
