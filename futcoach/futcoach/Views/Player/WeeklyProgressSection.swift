//
//  WeeklyProgressSection.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 6.01.2026.
//

import SwiftUI

/// Container view for the weekly progress section on the dashboard
struct WeeklyProgressSection: View {
    let weeklyStats: [DailyStats]
    @Binding var selectedMetric: HealthMetric
    var streak: Int = 0
    var onSyncTapped: (() -> Void)? = nil
    
    @State private var selectedDay: DailyStats? = nil
    
    private var hasData: Bool {
        weeklyStats.contains { $0.steps > 0 || $0.distance > 0 || $0.activeEnergy > 0 }
    }
    
    /// Check if any heart rate data exists
    private var hasHeartRateData: Bool {
        weeklyStats.contains { $0.heartRate != nil && $0.heartRate! > 0 }
    }
    
    /// Calculate summary for current metric
    private var summary: WeeklySummary {
        let repository = DailyStatsRepository()
        return repository.calculateWeeklySummary(stats: weeklyStats, metric: selectedMetric)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header
            HStack {
                Image(systemName: "chart.xyaxis.line")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
                
                Text("Weekly Progress")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                if hasData {
                    // Week indicator
                    Text("Last 7 days")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            .padding(.horizontal)
            
            if hasData {
                // Metric selector chips
                MetricChipsView(
                    selectedMetric: $selectedMetric,
                    showHeartRate: hasHeartRateData
                )
                
                // Summary bar
                WeeklySummaryBar(
                    summary: summary,
                    metric: selectedMetric,
                    streak: streak
                )
                .padding(.horizontal)
                
                // Chart
                WeeklyLineChart(
                    data: weeklyStats,
                    metric: selectedMetric,
                    selectedDay: $selectedDay
                )
                .padding(.horizontal)
                
            } else {
                // Empty state
                ChartEmptyStateView(onSyncTapped: onSyncTapped)
                    .padding(.horizontal)
            }
        }
    }
}

#Preview("With Data") {
    ZStack {
        LinearGradient(
            colors: [Color.primaryGradientStart, Color.primaryGradientMiddle, Color.primaryGradientEnd],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        ScrollView {
            WeeklyProgressSection(
                weeklyStats: (0..<7).map { dayOffset in
                    DailyStats(
                        userId: "preview",
                        date: Calendar.current.date(byAdding: .day, value: -6 + dayOffset, to: Date())!,
                        steps: Int.random(in: 3000...12000),
                        distance: Double.random(in: 2...8) * 1000,
                        activeEnergy: Double.random(in: 200...600),
                        heartRate: Double.random(in: 60...100)
                    )
                },
                selectedMetric: .constant(.steps),
                streak: 5
            )
            .padding(.vertical)
        }
    }
}

#Preview("Empty State") {
    ZStack {
        LinearGradient(
            colors: [Color.primaryGradientStart, Color.primaryGradientMiddle, Color.primaryGradientEnd],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        ScrollView {
            WeeklyProgressSection(
                weeklyStats: [],
                selectedMetric: .constant(.steps),
                streak: 0,
                onSyncTapped: { print("Sync!") }
            )
            .padding(.vertical)
        }
    }
}
