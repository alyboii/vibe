//
//  PlayerDashboardView.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 5.01.2026.
//

import SwiftUI

struct PlayerDashboardView: View {
    let userId: String
    @StateObject private var viewModel: PlayerDashboardViewModel
    
    init(userId: String) {
        self.userId = userId
        _viewModel = StateObject(wrappedValue: PlayerDashboardViewModel(userId: userId))
    }
    
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
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Dashboard")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Track your daily progress")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            Task {
                                await viewModel.syncHealthKit()
                            }
                        }) {
                            HStack(spacing: 8) {
                                if viewModel.isSyncingHealthKit {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "arrow.triangle.2.circlepath")
                                        .font(.system(size: 16, weight: .semibold))
                                    Text("Sync")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(.white.opacity(0.2))
                            .cornerRadius(12)
                        }
                        .disabled(viewModel.isSyncingHealthKit)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // MARK: - Weekly Progress Charts
                    WeeklyProgressSection(
                        weeklyStats: viewModel.weeklyStats,
                        selectedMetric: $viewModel.selectedMetric,
                        streak: viewModel.currentStreak,
                        onSyncTapped: {
                            Task {
                                await viewModel.syncHealthKit()
                            }
                        }
                    )
                    
                    // MARK: - Today's Stats Section Header
                    if viewModel.dailyStats != nil {
                        HStack {
                            Image(systemName: "calendar")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text("Today")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    
                    // Stats Cards
                    if let stats = viewModel.dailyStats {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            StatCard(
                                icon: "figure.walk",
                                title: "Steps",
                                value: "\(stats.steps)",
                                color: .green
                            )
                            
                            StatCard(
                                icon: "location.fill",
                                title: "Distance",
                                value: String(format: "%.2f km", stats.distanceInKm),
                                color: .blue
                            )
                            
                            StatCard(
                                icon: "flame.fill",
                                title: "Calories",
                                value: "\(Int(stats.activeEnergy))",
                                color: .orange
                            )
                            
                            if let heartRate = stats.heartRate {
                                StatCard(
                                    icon: "heart.fill",
                                    title: "Heart Rate",
                                    value: "\(Int(heartRate)) bpm",
                                    color: .red
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Error Message
                    if let errorMessage = viewModel.errorMessage {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red.opacity(0.9))
                            
                            Text(errorMessage)
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.9))
                            
                            Spacer()
                            
                            Button(action: {
                                viewModel.clearError()
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        }
                        .padding()
                        .background(.red.opacity(0.2))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 20)
                }
            }
        }
        .task {
            await viewModel.loadDashboardData()
        }
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
                
                Text(value)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .cardStyle()
    }
}

#Preview {
    PlayerDashboardView(userId: "test-user-id")
}
