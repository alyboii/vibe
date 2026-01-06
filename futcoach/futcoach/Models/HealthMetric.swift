//
//  HealthMetric.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 6.01.2026.
//

import SwiftUI

/// Represents the different health metrics that can be tracked and displayed in charts
enum HealthMetric: String, CaseIterable, Identifiable {
    case steps
    case distance
    case calories
    case heartRate
    
    var id: String { rawValue }
    
    /// Display name for UI labels
    var displayName: String {
        switch self {
        case .steps: return "Steps"
        case .distance: return "Distance"
        case .calories: return "Calories"
        case .heartRate: return "Heart Rate"
        }
    }
    
    /// SF Symbol icon name
    var icon: String {
        switch self {
        case .steps: return "figure.walk"
        case .distance: return "location.fill"
        case .calories: return "flame.fill"
        case .heartRate: return "heart.fill"
        }
    }
    
    /// Unit suffix for display
    var unit: String {
        switch self {
        case .steps: return "steps"
        case .distance: return "km"
        case .calories: return "kcal"
        case .heartRate: return "bpm"
        }
    }
    
    /// Accent color for charts and UI elements
    var color: Color {
        switch self {
        case .steps: return .green
        case .distance: return .blue
        case .calories: return .orange
        case .heartRate: return .red
        }
    }
    
    /// Extract the corresponding value from a DailyStats object
    func value(from stats: DailyStats) -> Double {
        switch self {
        case .steps:
            return Double(stats.steps)
        case .distance:
            return stats.distanceInKm
        case .calories:
            return stats.activeEnergy
        case .heartRate:
            return stats.heartRate ?? 0
        }
    }
    
    /// Format a value for display with appropriate precision
    func formatValue(_ value: Double) -> String {
        switch self {
        case .steps:
            if value >= 1000 {
                return String(format: "%.1fK", value / 1000)
            }
            return String(format: "%.0f", value)
        case .distance:
            return String(format: "%.1f", value)
        case .calories:
            if value >= 1000 {
                return String(format: "%.1fK", value / 1000)
            }
            return String(format: "%.0f", value)
        case .heartRate:
            return String(format: "%.0f", value)
        }
    }
    
    /// Format value with unit for full display
    func formatValueWithUnit(_ value: Double) -> String {
        "\(formatValue(value)) \(unit)"
    }
    
    /// Whether this metric can have missing data (nil) values
    var isOptional: Bool {
        self == .heartRate
    }
}
