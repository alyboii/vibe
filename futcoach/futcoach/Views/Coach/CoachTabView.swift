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
                    Label("Players", systemImage: "person.3")
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
    CoachTabView()
}
