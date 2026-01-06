//
//  MetricChipsView.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 6.01.2026.
//

import SwiftUI

/// Horizontal scrollable chips for selecting a health metric
struct MetricChipsView: View {
    @Binding var selectedMetric: HealthMetric
    var showHeartRate: Bool = true
    
    private var availableMetrics: [HealthMetric] {
        if showHeartRate {
            return HealthMetric.allCases
        } else {
            return HealthMetric.allCases.filter { $0 != .heartRate }
        }
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(availableMetrics) { metric in
                    MetricChip(
                        metric: metric,
                        isSelected: selectedMetric == metric
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedMetric = metric
                        }
                        HapticManager.selection()
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

/// Individual metric chip button
struct MetricChip: View {
    let metric: HealthMetric
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: metric.icon)
                    .font(.system(size: 14, weight: .semibold))
                
                Text(metric.displayName)
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(isSelected ? .white : .white.opacity(0.7))
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(isSelected ? metric.color.opacity(0.8) : .white.opacity(0.1))
            )
            .overlay(
                Capsule()
                    .stroke(isSelected ? metric.color : .white.opacity(0.2), lineWidth: 1)
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .shadow(color: isSelected ? metric.color.opacity(0.4) : .clear, radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(metric.displayName) metric")
        .accessibilityHint(isSelected ? "Currently selected" : "Double tap to select")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
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
        
        VStack {
            MetricChipsView(selectedMetric: .constant(.steps))
            MetricChipsView(selectedMetric: .constant(.calories), showHeartRate: false)
        }
    }
}
