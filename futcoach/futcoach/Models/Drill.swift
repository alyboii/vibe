//
//  Drill.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 7.01.2026.
//

import Foundation
import FirebaseFirestore
import SwiftUI

// MARK: - Enums

enum DrillCategory: String, Codable, CaseIterable {
    case warmupPrevention = "warmup_prevention"
    case technicalPassing = "technical_passing"
    case technicalDribbling = "technical_dribbling"
    case technicalShooting = "technical_shooting"
    case speedAgility = "speed_agility"
    case strengthPlyometrics = "strength_plyometrics"
    case conditioning = "conditioning"
    case mobilityRecovery = "mobility_recovery"
    
    var displayName: String {
        switch self {
        case .warmupPrevention: return "Isınma & Sakatlık Önleme"
        case .technicalPassing: return "Pas & Kontrol"
        case .technicalDribbling: return "Dribbling & 1v1"
        case .technicalShooting: return "Şut & Bitiricilik"
        case .speedAgility: return "Hız & Çeviklik"
        case .strengthPlyometrics: return "Kuvvet & Plyo"
        case .conditioning: return "Kondisyon"
        case .mobilityRecovery: return "Mobilite & Toparlanma"
        }
    }
    
    var icon: String {
        switch self {
        case .warmupPrevention: return "figure.walk"
        case .technicalPassing: return "arrow.left.arrow.right"
        case .technicalDribbling: return "figure.soccer"
        case .technicalShooting: return "sportscourt"
        case .speedAgility: return "hare"
        case .strengthPlyometrics: return "figure.strengthtraining.traditional"
        case .conditioning: return "heart.circle"
        case .mobilityRecovery: return "figure.cooldown"
        }
    }
    
    var color: Color {
        switch self {
        case .warmupPrevention: return .orange
        case .technicalPassing: return .blue
        case .technicalDribbling: return .purple
        case .technicalShooting: return .red
        case .speedAgility: return .yellow
        case .strengthPlyometrics: return .green
        case .conditioning: return .pink
        case .mobilityRecovery: return .cyan
        }
    }
}

enum DrillLevel: String, Codable, CaseIterable {
    case beginner
    case intermediate
    case advanced
    
    var displayName: String {
        switch self {
        case .beginner: return "Başlangıç"
        case .intermediate: return "Orta"
        case .advanced: return "İleri"
        }
    }
}

enum TargetType: String, Codable {
    case technical
    case physical
    case tactical
    case prevention
    case conditioning
    case recovery
}

enum LogFormat: String, Codable {
    case countBased       // tekrar, başarılı/başarısız
    case timeBased        // süre, interval
    case loadBased        // set, tekrar, ağırlık, RPE
    case accuracyBased    // isabet/deneme
    case completionOnly   // sadece tamamlandı
    case ratingOnly       // zorluk/yorgunluk 1-10
    
    var displayName: String {
        switch self {
        case .countBased: return "Sayı Bazlı"
        case .timeBased: return "Süre Bazlı"
        case .loadBased: return "Yük Bazlı"
        case .accuracyBased: return "İsabet Bazlı"
        case .completionOnly: return "Tamamlama"
        case .ratingOnly: return "Değerlendirme"
        }
    }
}

// MARK: - Drill Model

struct Drill: Identifiable, Codable {
    @DocumentID var id: String?
    let name: String
    let nameEN: String
    let category: DrillCategory
    let subcategory: String?
    let targetType: TargetType
    let equipment: [String]
    let level: DrillLevel
    let durationMinutes: Int?
    let sets: Int?
    let reps: Int?
    let description: String
    let coachingTips: [String]
    let safetyNotes: String?
    let logFormat: LogFormat
    let videoURL: String?
    let thumbnailURL: String?
    let order: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case nameEN = "name_en"
        case category
        case subcategory
        case targetType = "target_type"
        case equipment
        case level
        case durationMinutes = "duration_minutes"
        case sets
        case reps
        case description
        case coachingTips = "coaching_tips"
        case safetyNotes = "safety_notes"
        case logFormat = "log_format"
        case videoURL = "video_url"
        case thumbnailURL = "thumbnail_url"
        case order
    }
    
    init(
        id: String? = nil,
        name: String,
        nameEN: String = "",
        category: DrillCategory,
        subcategory: String? = nil,
        targetType: TargetType,
        equipment: [String] = [],
        level: DrillLevel = .beginner,
        durationMinutes: Int? = nil,
        sets: Int? = nil,
        reps: Int? = nil,
        description: String = "",
        coachingTips: [String] = [],
        safetyNotes: String? = nil,
        logFormat: LogFormat = .completionOnly,
        videoURL: String? = nil,
        thumbnailURL: String? = nil,
        order: Int = 0
    ) {
        self.id = id
        self.name = name
        self.nameEN = nameEN
        self.category = category
        self.subcategory = subcategory
        self.targetType = targetType
        self.equipment = equipment
        self.level = level
        self.durationMinutes = durationMinutes
        self.sets = sets
        self.reps = reps
        self.description = description
        self.coachingTips = coachingTips
        self.safetyNotes = safetyNotes
        self.logFormat = logFormat
        self.videoURL = videoURL
        self.thumbnailURL = thumbnailURL
        self.order = order
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "name": name,
            "name_en": nameEN,
            "category": category.rawValue,
            "target_type": targetType.rawValue,
            "equipment": equipment,
            "level": level.rawValue,
            "description": description,
            "coaching_tips": coachingTips,
            "log_format": logFormat.rawValue,
            "order": order
        ]
        
        if let subcategory = subcategory { dict["subcategory"] = subcategory }
        if let durationMinutes = durationMinutes { dict["duration_minutes"] = durationMinutes }
        if let sets = sets { dict["sets"] = sets }
        if let reps = reps { dict["reps"] = reps }
        if let safetyNotes = safetyNotes { dict["safety_notes"] = safetyNotes }
        if let videoURL = videoURL { dict["video_url"] = videoURL }
        if let thumbnailURL = thumbnailURL { dict["thumbnail_url"] = thumbnailURL }
        
        return dict
    }
    
    static func fromFirestore(_ document: DocumentSnapshot) -> Drill? {
        guard let data = document.data() else { return nil }
        
        let categoryString = data["category"] as? String ?? ""
        let category = DrillCategory(rawValue: categoryString) ?? .warmupPrevention
        
        let targetTypeString = data["target_type"] as? String ?? ""
        let targetType = TargetType(rawValue: targetTypeString) ?? .technical
        
        let levelString = data["level"] as? String ?? ""
        let level = DrillLevel(rawValue: levelString) ?? .beginner
        
        let logFormatString = data["log_format"] as? String ?? ""
        let logFormat = LogFormat(rawValue: logFormatString) ?? .completionOnly
        
        return Drill(
            id: document.documentID,
            name: data["name"] as? String ?? "",
            nameEN: data["name_en"] as? String ?? "",
            category: category,
            subcategory: data["subcategory"] as? String,
            targetType: targetType,
            equipment: data["equipment"] as? [String] ?? [],
            level: level,
            durationMinutes: data["duration_minutes"] as? Int,
            sets: data["sets"] as? Int,
            reps: data["reps"] as? Int,
            description: data["description"] as? String ?? "",
            coachingTips: data["coaching_tips"] as? [String] ?? [],
            safetyNotes: data["safety_notes"] as? String,
            logFormat: logFormat,
            videoURL: data["video_url"] as? String,
            thumbnailURL: data["thumbnail_url"] as? String,
            order: data["order"] as? Int ?? 0
        )
    }
    
    /// Format for display: "3x12" or "5 dk" or "10 tekrar"
    var formatDisplay: String {
        if let sets = sets, let reps = reps {
            return "\(sets)x\(reps)"
        } else if let durationMinutes = durationMinutes {
            return "\(durationMinutes) dk"
        } else if let reps = reps {
            return "\(reps) tekrar"
        } else if let sets = sets {
            return "\(sets) set"
        }
        return ""
    }
}
