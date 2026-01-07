//
//  Assignment.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 7.01.2026.
//

import Foundation
import FirebaseFirestore

// MARK: - Assignment Status

enum AssignmentStatus: String, Codable, CaseIterable {
    case pending
    case inProgress = "in_progress"
    case completed
    case overdue
    case cancelled
    
    var displayName: String {
        switch self {
        case .pending: return "Bekliyor"
        case .inProgress: return "Devam Ediyor"
        case .completed: return "Tamamlandı"
        case .overdue: return "Gecikmiş"
        case .cancelled: return "İptal"
        }
    }
    
    var icon: String {
        switch self {
        case .pending: return "clock"
        case .inProgress: return "play.circle"
        case .completed: return "checkmark.circle.fill"
        case .overdue: return "exclamationmark.circle"
        case .cancelled: return "xmark.circle"
        }
    }
}

// MARK: - Assignment Target

struct AssignmentTarget: Codable {
    let type: String          // "set", "rep", "shot", "minute", "completion"
    let value: Int            // Hedef değer
    let unit: String          // Görüntüleme birimi
    let successCriteria: Int? // Başarı kriteri (örn. 7 isabet)
    
    init(type: String, value: Int, unit: String, successCriteria: Int? = nil) {
        self.type = type
        self.value = value
        self.unit = unit
        self.successCriteria = successCriteria
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "type": type,
            "value": value,
            "unit": unit
        ]
        if let successCriteria = successCriteria {
            dict["success_criteria"] = successCriteria
        }
        return dict
    }
    
    static func fromDictionary(_ data: [String: Any]) -> AssignmentTarget {
        return AssignmentTarget(
            type: data["type"] as? String ?? "",
            value: data["value"] as? Int ?? 0,
            unit: data["unit"] as? String ?? "",
            successCriteria: data["success_criteria"] as? Int
        )
    }
    
    /// Display format: "5 set" or "10 şut / 7 isabet"
    var displayFormat: String {
        if let criteria = successCriteria {
            return "\(value) \(unit) / \(criteria) isabet"
        }
        return "\(value) \(unit)"
    }
}

// MARK: - Assignment Model

struct Assignment: Identifiable, Codable {
    @DocumentID var id: String?
    let coachId: String
    let teamId: String
    let playerId: String?         // nil = tüm takıma atanmış
    let drillId: String
    let drillName: String         // Denormalized
    let drillCategory: DrillCategory
    let target: AssignmentTarget
    let dueDate: Date
    let createdAt: Date
    var status: AssignmentStatus
    var completedAt: Date?
    var notes: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case coachId = "coach_id"
        case teamId = "team_id"
        case playerId = "player_id"
        case drillId = "drill_id"
        case drillName = "drill_name"
        case drillCategory = "drill_category"
        case target
        case dueDate = "due_date"
        case createdAt = "created_at"
        case status
        case completedAt = "completed_at"
        case notes
    }
    
    init(
        id: String? = nil,
        coachId: String,
        teamId: String,
        playerId: String? = nil,
        drillId: String,
        drillName: String,
        drillCategory: DrillCategory,
        target: AssignmentTarget,
        dueDate: Date,
        createdAt: Date = Date(),
        status: AssignmentStatus = .pending,
        completedAt: Date? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.coachId = coachId
        self.teamId = teamId
        self.playerId = playerId
        self.drillId = drillId
        self.drillName = drillName
        self.drillCategory = drillCategory
        self.target = target
        self.dueDate = dueDate
        self.createdAt = createdAt
        self.status = status
        self.completedAt = completedAt
        self.notes = notes
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "coach_id": coachId,
            "team_id": teamId,
            "drill_id": drillId,
            "drill_name": drillName,
            "drill_category": drillCategory.rawValue,
            "target": target.toDictionary(),
            "due_date": Timestamp(date: dueDate),
            "created_at": Timestamp(date: createdAt),
            "status": status.rawValue
        ]
        
        if let playerId = playerId { dict["player_id"] = playerId }
        if let completedAt = completedAt { dict["completed_at"] = Timestamp(date: completedAt) }
        if let notes = notes { dict["notes"] = notes }
        
        return dict
    }
    
    static func fromFirestore(_ document: DocumentSnapshot) -> Assignment? {
        guard let data = document.data() else { return nil }
        
        let categoryString = data["drill_category"] as? String ?? ""
        let category = DrillCategory(rawValue: categoryString) ?? .warmupPrevention
        
        let statusString = data["status"] as? String ?? "pending"
        let status = AssignmentStatus(rawValue: statusString) ?? .pending
        
        let targetData = data["target"] as? [String: Any] ?? [:]
        let target = AssignmentTarget.fromDictionary(targetData)
        
        return Assignment(
            id: document.documentID,
            coachId: data["coach_id"] as? String ?? "",
            teamId: data["team_id"] as? String ?? "",
            playerId: data["player_id"] as? String,
            drillId: data["drill_id"] as? String ?? "",
            drillName: data["drill_name"] as? String ?? "",
            drillCategory: category,
            target: target,
            dueDate: (data["due_date"] as? Timestamp)?.dateValue() ?? Date(),
            createdAt: (data["created_at"] as? Timestamp)?.dateValue() ?? Date(),
            status: status,
            completedAt: (data["completed_at"] as? Timestamp)?.dateValue(),
            notes: data["notes"] as? String
        )
    }
    
    /// Check if assignment is overdue
    var isOverdue: Bool {
        return status != .completed && status != .cancelled && dueDate < Date()
    }
    
    /// Days until due date (negative if overdue)
    var daysUntilDue: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: dueDate)
        return components.day ?? 0
    }
    
    /// Human readable due date
    var dueDateDisplay: String {
        let days = daysUntilDue
        if days == 0 { return "Bugün" }
        if days == 1 { return "Yarın" }
        if days == -1 { return "Dün" }
        if days > 0 { return "\(days) gün sonra" }
        return "\(-days) gün önce"
    }
}
