//
//  HealthData.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 5.01.2026.
//

import Foundation

struct HealthData {
    var steps: Int
    var distance: Double
    var activeEnergy: Double
    var heartRate: Double?
    var date: Date
    
    init(steps: Int = 0, distance: Double = 0, activeEnergy: Double = 0, heartRate: Double? = nil, date: Date = Date()) {
        self.steps = steps
        self.distance = distance
        self.activeEnergy = activeEnergy
        self.heartRate = heartRate
        self.date = date
    }
    
    // Validation helpers
    var isValid: Bool {
        steps >= 0 && distance >= 0 && activeEnergy >= 0
    }
    
    // Convert to DailyStats
    func toDailyStats(userId: String) -> DailyStats {
        return DailyStats(
            userId: userId,
            date: date,
            steps: steps,
            distance: distance,
            activeEnergy: activeEnergy,
            heartRate: heartRate
        )
    }
    
    // Format for AI service
    func toAIPayload() -> [String: Any] {
        var payload: [String: Any] = [
            "steps": steps,
            "distance": distance,
            "active_energy": activeEnergy,
            "date": ISO8601DateFormatter().string(from: date)
        ]
        
        if let heartRate = heartRate {
            payload["heart_rate"] = heartRate
        }
        
        return payload
    }
}
