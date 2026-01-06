//
//  CoachDashboardView.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 5.01.2026.
//

import SwiftUI

struct CoachDashboardView: View {
    @StateObject private var viewModel = CoachDashboardViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.primaryGradientStart, Color.primaryGradientMiddle, Color.primaryGradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Coach Dashboard")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Monitor your team's performance")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // Stats Summary
                    HStack(spacing: 16) {
                        InfoCard(
                            title: "Total Players",
                            value: "\(viewModel.players.count)",
                            icon: "person.3.fill",
                            color: .blue
                        )
                        
                        InfoCard(
                            title: "Active",
                            value: "\(viewModel.players.count)",
                            icon: "checkmark.circle.fill",
                            color: .green
                        )
                    }
                    .padding(.horizontal)
                    
                    // Recent Players
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recent Players")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        if viewModel.players.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "person.3")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white.opacity(0.3))
                                
                                Text("No players yet")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .padding(.vertical, 40)
                        } else {
                            ForEach(viewModel.players.prefix(5)) { player in
                                PlayerRow(player: player)
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Error Message
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 14))
                            .foregroundColor(.red.opacity(0.9))
                            .padding()
                            .background(.white.opacity(0.1))
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                }
            }
            .refreshable {
                await viewModel.refreshPlayers()
            }
        }
        .task {
            await viewModel.loadPlayers()
        }
    }
}

struct InfoCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .cardStyle()
    }
}

struct PlayerRow: View {
    let player: User
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(.white.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(String(player.fullName.prefix(1)))
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(player.fullName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(player.email)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.5))
        }
        .padding()
        .cardStyle()
    }
}

#Preview {
    CoachDashboardView()
}
