//
//  Team.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 7.01.2026.
//

import Foundation
import FirebaseFirestore

struct Team: Identifiable, Codable {
    @DocumentID var id: String?
    let coachId: String
    let name: String
    var teamCode: String
    var codeRotatedAt: Date
    let createdAt: Date
    var memberCount: Int
    var isActive: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case coachId = "coach_id"
        case name
        case teamCode = "team_code"
        case codeRotatedAt = "code_rotated_at"
        case createdAt = "created_at"
        case memberCount = "member_count"
        case isActive = "is_active"
    }
    
    init(
        id: String? = nil,
        coachId: String,
        name: String,
        teamCode: String = "",
        codeRotatedAt: Date = Date(),
        createdAt: Date = Date(),
        memberCount: Int = 0,
        isActive: Bool = true
    ) {
        self.id = id
        self.coachId = coachId
        self.name = name
        self.teamCode = teamCode
        self.codeRotatedAt = codeRotatedAt
        self.createdAt = createdAt
        self.memberCount = memberCount
        self.isActive = isActive
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "coach_id": coachId,
            "name": name,
            "team_code": teamCode,
            "code_rotated_at": Timestamp(date: codeRotatedAt),
            "created_at": Timestamp(date: createdAt),
            "member_count": memberCount,
            "is_active": isActive
        ]
    }
    
    static func fromFirestore(_ document: DocumentSnapshot) -> Team? {
        guard let data = document.data() else { return nil }
        
        return Team(
            id: document.documentID,
            coachId: data["coach_id"] as? String ?? "",
            name: data["name"] as? String ?? "",
            teamCode: data["team_code"] as? String ?? "",
            codeRotatedAt: (data["code_rotated_at"] as? Timestamp)?.dateValue() ?? Date(),
            createdAt: (data["created_at"] as? Timestamp)?.dateValue() ?? Date(),
            memberCount: data["member_count"] as? Int ?? 0,
            isActive: data["is_active"] as? Bool ?? true
        )
    }
    
    /// Generate a unique 4-digit team code
    static func generateCode() -> String {
        let code = Int.random(in: 0...9999)
        return String(format: "%04d", code)
    }
}
