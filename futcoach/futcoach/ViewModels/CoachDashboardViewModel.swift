//
//  CoachDashboardViewModel.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 5.01.2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class CoachDashboardViewModel: ObservableObject {
    @Published var players: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let userRepository = UserRepository()
    
    // Load all players
    func loadPlayers() async {
        isLoading = true
        errorMessage = nil
        
        do {
            players = try await userRepository.getAllPlayers()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // Refresh players list
    func refreshPlayers() async {
        await loadPlayers()
    }
    
    // Clear error
    func clearError() {
        errorMessage = nil
    }
}
