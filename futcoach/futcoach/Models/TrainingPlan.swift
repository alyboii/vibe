//
//  TrainingPlan.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 5.01.2026.
//

import Foundation
import FirebaseFirestore

struct TrainingPlan: Identifiable, Codable {
    @DocumentID var id: String?
    let userId: String
    let planData: String // JSON string or formatted text from AI
    let generatedAt: Date
    var weekNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case planData = "plan_data"
        case generatedAt = "generated_at"
        case weekNumber = "week_number"
    }
    
    init(id: String? = nil, userId: String, planData: String, generatedAt: Date = Date(), weekNumber: Int = 1) {
        self.id = id
        self.userId = userId
        self.planData = planData
        self.generatedAt = generatedAt
        self.weekNumber = weekNumber
    }
    
    // Firestore mapping
    func toDictionary() -> [String: Any] {
        return [
            "user_id": userId,
            "plan_data": planData,
            "generated_at": Timestamp(date: generatedAt),
            "week_number": weekNumber
        ]
    }
    
    static func fromFirestore(_ document: DocumentSnapshot) -> TrainingPlan? {
        guard let data = document.data() else { return nil }
        
        let userId = data["user_id"] as? String ?? ""
        let planData = data["plan_data"] as? String ?? ""
        let timestamp = data["generated_at"] as? Timestamp
        let generatedAt = timestamp?.dateValue() ?? Date()
        let weekNumber = data["week_number"] as? Int ?? 1
        
        return TrainingPlan(
            id: document.documentID,
            userId: userId,
            planData: planData,
            generatedAt: generatedAt,
            weekNumber: weekNumber
        )
    }
}
