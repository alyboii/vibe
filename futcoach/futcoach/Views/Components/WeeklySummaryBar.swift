//
//  WeeklySummaryBar.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 6.01.2026.
//

import SwiftUI

/// Horizontal bar showing weekly summary statistics
struct WeeklySummaryBar: View {
    let summary: WeeklySummary
    let metric: HealthMetric
    var streak: Int = 0
    
    var body: some View {
        HStack(spacing: 0) {
            // Total
            SummaryItem(
                title: "7-Day Total",
                value: metric.formatValue(summary.total),
                icon: "sum"
            )
            
            Divider()
                .frame(width: 1, height: 40)
                .background(.white.opacity(0.2))
            
            // Average
            SummaryItem(
                title: "Daily Avg",
                value: metric.formatValue(summary.average),
                icon: "chart.bar"
            )
            
            Divider()
                .frame(width: 1, height: 40)
                .background(.white.opacity(0.2))
            
            // Best Day
            SummaryItem(
                title: "Best Day",
                value: summary.bestDayFormatted,
                icon: "star.fill"
            )
            
            Divider()
                .frame(width: 1, height: 40)
                .background(.white.opacity(0.2))
            
            // Streak
            StreakItem(streak: streak)
        }
        .padding(.vertical, 16)
        .cardStyle()
    }
}

/// Individual summary statistic item
private struct SummaryItem: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.5))
            
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .contentTransition(.numericText())
            
            Text(title)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(value)")
    }
}

/// Streak display with fire emoji
private struct StreakItem: View {
    let streak: Int
    
    var body: some View {
        VStack(spacing: 6) {
            Text("🔥")
                .font(.system(size: 14))
            
            HStack(spacing: 2) {
                Text("\(streak)")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .contentTransition(.numericText())
            }
            
            Text("Streak")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .accessibilityLabel("Current streak: \(streak) days")
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [Color.primaryGradientStart, Color.primaryGradientMiddle, Color.primaryGradientEnd],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        VStack(spacing: 20) {
            WeeklySummaryBar(
                summary: WeeklySummary(
                    total: 52450,
                    average: 7492,
                    bestDay: Date(),
                    bestValue: 12340,
                    daysWithData: 6
                ),
                metric: .steps,
                streak: 5
            )
            .padding(.horizontal)
            
            WeeklySummaryBar(
                summary: .empty,
                metric: .distance,
                streak: 0
            )
            .padding(.horizontal)
        }
    }
}
