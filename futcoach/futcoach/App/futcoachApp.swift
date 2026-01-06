//
//  futcoachApp.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 5.01.2026.
//

import SwiftUI
import FirebaseCore

@main
struct futcoachApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    init() {
        // Configure Firebase
        FirebaseService.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RootView()
            }
            .environmentObject(authViewModel)
        }
    }
}

struct RootView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            if !authViewModel.isAuthenticated {
                // Not authenticated - show sign in
                SignInView()
            } else if let user = authViewModel.currentUser {
                if user.role == nil {
                    // Authenticated but no role - show role selection
                    RoleSelectionView()
                } else if user.role == .player {
                    // Player role
                    PlayerTabView()
                } else if user.role == .coach {
                    // Coach role
                    CoachTabView()
                }
            } else {
                // Loading state
                ZStack {
                    LinearGradient(
                        colors: [Color.primaryGradientStart, Color.primaryGradientMiddle, Color.primaryGradientEnd],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AuthViewModel())
}
