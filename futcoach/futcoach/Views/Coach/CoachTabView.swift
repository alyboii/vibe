//
//  CoachTabView.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 5.01.2026.
//

import SwiftUI

struct CoachTabView: View {
    var body: some View {
        TabView {
            CoachDashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
            
            PlayersListView()
                .tabItem {
                    Label("Oyuncular", systemImage: "person.3")
                }
            
            TeamManagementView()
                .tabItem {
                    Label("Takım", systemImage: "person.badge.key")
                }
            
            DrillLibraryView()
                .tabItem {
                    Label("Driller", systemImage: "figure.soccer")
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
    CoachTabView()
}
