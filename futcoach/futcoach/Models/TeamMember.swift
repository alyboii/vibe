//
//  TeamMember.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 7.01.2026.
//

import Foundation
import FirebaseFirestore

enum MemberStatus: String, Codable {
    case active
    case inactive
    case removed
}

struct TeamMember: Identifiable, Codable {
    @DocumentID var id: String?
    let teamId: String
    let playerId: String
    let playerName: String      // Denormalized for quick display
    let playerEmail: String     // Denormalized for quick display
    let joinedAt: Date
    var status: MemberStatus
    var invitedBy: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case teamId = "team_id"
        case playerId = "player_id"
        case playerName = "player_name"
        case playerEmail = "player_email"
        case joinedAt = "joined_at"
        case status
        case invitedBy = "invited_by"
    }
    
    init(
        id: String? = nil,
        teamId: String,
        playerId: String,
        playerName: String,
        playerEmail: String,
        joinedAt: Date = Date(),
        status: MemberStatus = .active,
        invitedBy: String? = nil
    ) {
        self.id = id
        self.teamId = teamId
        self.playerId = playerId
        self.playerName = playerName
        self.playerEmail = playerEmail
        self.joinedAt = joinedAt
        self.status = status
        self.invitedBy = invitedBy
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "team_id": teamId,
            "player_id": playerId,
            "player_name": playerName,
            "player_email": playerEmail,
            "joined_at": Timestamp(date: joinedAt),
            "status": status.rawValue
        ]
        
        if let invitedBy = invitedBy {
            dict["invited_by"] = invitedBy
        }
        
        return dict
    }
    
    static func fromFirestore(_ document: DocumentSnapshot) -> TeamMember? {
        guard let data = document.data() else { return nil }
        
        let statusString = data["status"] as? String ?? "active"
        let status = MemberStatus(rawValue: statusString) ?? .active
        
        return TeamMember(
            id: document.documentID,
            teamId: data["team_id"] as? String ?? "",
            playerId: data["player_id"] as? String ?? "",
            playerName: data["player_name"] as? String ?? "",
            playerEmail: data["player_email"] as? String ?? "",
            joinedAt: (data["joined_at"] as? Timestamp)?.dateValue() ?? Date(),
            status: status,
            invitedBy: data["invited_by"] as? String
        )
    }
    
    /// Create document ID from team and player IDs for easy lookup
    static func documentId(teamId: String, playerId: String) -> String {
        return "\(teamId)_\(playerId)"
    }
}
