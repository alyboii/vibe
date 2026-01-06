//
//  RoleSelectionViewModel.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 5.01.2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class RoleSelectionViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedRole: UserRole?
    
    private let userRepository = UserRepository()
    
    // Select role
    func selectRole(_ role: UserRole, for userId: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await userRepository.updateUserRole(userId: userId, role: role)
            selectedRole = role
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
