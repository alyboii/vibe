//
//  WeeklySummary.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 6.01.2026.
//

import Foundation

/// Summary statistics for a week of health data
struct WeeklySummary {
    /// Total value for the week (sum of all days)
    let total: Double
    
    /// Average value per day (only counting days with data)
    let average: Double
    
    /// Date of the best performing day
    let bestDay: Date?
    
    /// Value on the best day
    let bestValue: Double
    
    /// Number of days that have recorded data
    let daysWithData: Int
    
    /// Whether there's any data for this week
    var hasData: Bool {
        daysWithData > 0
    }
    
    /// Format the best day as a short weekday string
    var bestDayFormatted: String {
        guard let bestDay = bestDay else { return "—" }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: bestDay)
    }
    
    /// Empty summary for when there's no data
    static var empty: WeeklySummary {
        WeeklySummary(
            total: 0,
            average: 0,
            bestDay: nil,
            bestValue: 0,
            daysWithData: 0
        )
    }
}
