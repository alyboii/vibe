//
//  PlayerTab View.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 5.01.2026.
//

import SwiftUI

struct PlayerTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var userId: String {
        authViewModel.currentUser?.id ?? ""
    }
    
    var body: some View {
        TabView {
            PlayerDashboardView(userId: userId)
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
            
            HealthDataEntryView(userId: userId)
                .tabItem {
                    Label("Health Data", systemImage: "heart.fill")
                }
            
            TrainingPlanView(userId: userId)
                .tabItem {
                    Label("Training Plan", systemImage: "figure.run")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
        .accentColor(.white)
    }
}

#Preview {
    PlayerTabView()
        .environmentObject(AuthViewModel())
}
