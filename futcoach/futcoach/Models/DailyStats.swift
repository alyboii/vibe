//
//  DailyStats.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 5.01.2026.
//

import Foundation
import FirebaseFirestore

struct DailyStats: Identifiable, Codable {
    @DocumentID var id: String?
    let userId: String
    let date: Date
    var steps: Int
    var distance: Double // in meters
    var activeEnergy: Double // in kcal
    var heartRate: Double? // average heart rate
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case date
        case steps
        case distance
        case activeEnergy = "active_energy"
        case heartRate = "heart_rate"
    }
    
    init(id: String? = nil, userId: String, date: Date, steps: Int = 0, distance: Double = 0, activeEnergy: Double = 0, heartRate: Double? = nil) {
        self.id = id
        self.userId = userId
        self.date = date
        self.steps = steps
        self.distance = distance
        self.activeEnergy = activeEnergy
        self.heartRate = heartRate
    }
    
    // Firestore mapping
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "user_id": userId,
            "date": Timestamp(date: date),
            "steps": steps,
            "distance": distance,
            "active_energy": activeEnergy
        ]
        
        if let heartRate = heartRate {
            dict["heart_rate"] = heartRate
        }
        
        return dict
    }
    
    static func fromFirestore(_ document: DocumentSnapshot) -> DailyStats? {
        guard let data = document.data() else { return nil }
        
        let userId = data["user_id"] as? String ?? ""
        let timestamp = data["date"] as? Timestamp
        let date = timestamp?.dateValue() ?? Date()
        let steps = data["steps"] as? Int ?? 0
        let distance = data["distance"] as? Double ?? 0.0
        let activeEnergy = data["active_energy"] as? Double ?? 0.0
        let heartRate = data["heart_rate"] as? Double
        
        return DailyStats(
            id: document.documentID,
            userId: userId,
            date: date,
            steps: steps,
            distance: distance,
            activeEnergy: activeEnergy,
            heartRate: heartRate
        )
    }
    
    // Helper: Distance in kilometers
    var distanceInKm: Double {
        distance / 1000.0
    }
}
