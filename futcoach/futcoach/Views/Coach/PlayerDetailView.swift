//
//  PlayerDetailView.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 7.01.2026.
//

import SwiftUI
import Charts

struct PlayerDetailView: View {
    let player: User
    let teamId: String
    
    @StateObject private var workoutLogService = WorkoutLogService.shared
    @StateObject private var assignmentService = AssignmentService.shared
    @StateObject private var riskService = RiskService.shared
    
    @State private var logs: [WorkoutLog] = []
    @State private var weeklyStats: WeeklyWorkoutStats?
    @State private var assignmentStats: AssignmentStats?
    @State private var riskWarnings: [RiskWarning] = []
    @State private var isLoading = true
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color.primaryGradientStart, Color.primaryGradientMiddle, Color.primaryGradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Player Header
                    VStack(spacing: 16) {
                        // Avatar
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 80, height: 80)
                            
                            Text(player.initials)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 4) {
                            Text(player.fullName)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(player.email)
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                            
                            if let position = player.position {
                                Text(position)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    
                    // Risk Warnings
                    if !riskWarnings.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.orange)
                                Text("Risk Uyarıları")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            
                            ForEach(riskWarnings) { warning in
                                RiskWarningRow(warning: warning)
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                    }
                    
                    // Weekly Summary
                    if let stats = weeklyStats {
                        WeeklyStatsCard(stats: stats)
                    }
                    
                    // Assignment Stats
                    if let aStats = assignmentStats {
                        AssignmentStatsCard(stats: aStats)
                    }
                    
                    // Category Breakdown Chart
                    if !logs.isEmpty {
                        CategoryBreakdownChart(logs: logs)
                    }
                    
                    // Recent Activity
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Son Aktiviteler")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        if logs.isEmpty {
                            Text("Henüz aktivite yok")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.6))
                                .padding()
                        } else {
                            ForEach(logs.prefix(10)) { log in
                                ActivityRow(log: log)
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                }
                .padding()
                .padding(.bottom, 50)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadPlayerData()
        }
    }
    
    private func loadPlayerData() async {
        isLoading = true
        
        guard let playerId = player.id else { return }
        
        do {
            // Load logs
            logs = try await workoutLogService.getLogsInRange(
                playerId: playerId,
                startDate: Calendar.current.date(byAdding: .day, value: -30, to: Date())!,
                endDate: Date()
            )
            
            // Load weekly stats
            weeklyStats = try await workoutLogService.getWeeklyStats(playerId: playerId)
            
            // Load assignment stats
            assignmentStats = try await assignmentService.getPlayerStats(playerId: playerId)
            
            // Check risk warnings
            riskWarnings = try await riskService.checkRiskWarnings(playerId: playerId)
            
        } catch {
            print("Failed to load player data: \(error)")
        }
        
        isLoading = false
    }
}

// MARK: - Risk Warning Row

struct RiskWarningRow: View {
    let warning: RiskWarning
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: warning.severity.icon)
                .font(.system(size: 16))
                .foregroundColor(warning.severity.color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(warning.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(warning.message)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.7))
                
                Text(warning.recommendation)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(warning.severity.color)
            }
        }
        .padding(12)
        .background(warning.severity.color.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Weekly Stats Card

struct WeeklyStatsCard: View {
    let stats: WeeklyWorkoutStats
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Bu Hafta")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
            HStack(spacing: 16) {
                StatItem(value: "\(stats.totalWorkouts)", label: "Antrenman", icon: "figure.run", color: .green)
                StatItem(value: "\(stats.totalDurationMinutes)", label: "Dakika", icon: "clock", color: .blue)
                StatItem(value: "\(stats.streakDays)", label: "Gün", icon: "flame.fill", color: .orange)
                if let rpe = stats.averageRPE {
                    StatItem(value: String(format: "%.1f", rpe), label: "Ort. RPE", icon: "heart.fill", color: .red)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
}

struct StatItem: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Assignment Stats Card

struct AssignmentStatsCard: View {
    let stats: AssignmentStats
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Görev Durumu")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(String(format: "%.0f%%", stats.completionRate))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.green)
            }
            
            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.white.opacity(0.2))
                        .frame(height: 12)
                    
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [.green, .green.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * (stats.completionRate / 100), height: 12)
                }
            }
            .frame(height: 12)
            
            HStack {
                Label("\(stats.completed) tamamlandı", systemImage: "checkmark.circle.fill")
                    .foregroundColor(.green)
                
                Spacer()
                
                if stats.overdue > 0 {
                    Label("\(stats.overdue) gecikmiş", systemImage: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                }
            }
            .font(.system(size: 12))
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
}

// MARK: - Category Breakdown Chart

struct CategoryBreakdownChart: View {
    let logs: [WorkoutLog]
    
    private var categoryData: [(category: DrillCategory, count: Int)] {
        let grouped = Dictionary(grouping: logs) { $0.drillCategory }
        return DrillCategory.allCases.compactMap { category in
            guard let count = grouped[category]?.count, count > 0 else { return nil }
            return (category, count)
        }.sorted { $0.count > $1.count }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Kategori Dağılımı")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
            Chart(categoryData, id: \.category) { item in
                BarMark(
                    x: .value("Sayı", item.count),
                    y: .value("Kategori", item.category.displayName)
                )
                .foregroundStyle(item.category.color)
                .cornerRadius(4)
            }
            .chartXAxis {
                AxisMarks(position: .bottom) { _ in
                    AxisValueLabel()
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                    AxisValueLabel()
                        .foregroundStyle(.white.opacity(0.8))
                        .font(.system(size: 10))
                }
            }
            .frame(height: CGFloat(categoryData.count * 40 + 20))
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
}

// MARK: - Activity Row

struct ActivityRow: View {
    let log: WorkoutLog
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(log.drillCategory.color.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: log.drillCategory.icon)
                        .font(.system(size: 16))
                        .foregroundColor(log.drillCategory.color)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(log.drillName)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    Text(log.dateDisplay)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))
                    
                    if let rpe = log.rpe {
                        Text("RPE: \(rpe)")
                            .font(.system(size: 11))
                            .foregroundColor(.orange)
                    }
                }
            }
            
            Spacer()
            
            Text(log.metricsSummary)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    NavigationView {
        PlayerDetailView(
            player: User(
                id: "test",
                email: "player@test.com",
                fullName: "Ahmet Yılmaz",
                role: .player,
                position: "Orta Saha"
            ),
            teamId: "team1"
        )
    }
}
