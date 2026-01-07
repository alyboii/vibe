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
                    Label("Ana Sayfa", systemImage: "house.fill")
                }
            
            AssignedTasksView()
                .tabItem {
                    Label("Görevler", systemImage: "checklist")
                }
            
            DrillLibraryView()
                .tabItem {
                    Label("Driller", systemImage: "figure.soccer")
                }
            
            TrainingPlanView(userId: userId)
                .tabItem {
                    Label("Plan", systemImage: "figure.run")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person.circle")
                }
        }
        .accentColor(.white)
    }
}

#Preview {
    PlayerTabView()
        .environmentObject(AuthViewModel())
}
