//
//  User.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 5.01.2026.
//

import Foundation
import FirebaseFirestore

enum UserRole: String, Codable {
    case player
    case coach
}

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    let email: String
    let fullName: String
    var role: UserRole?
    let createdAt: Date
    
    // NEW: Team membership fields
    var teamId: String?
    var position: String?
    var birthDate: Date?
    var profileImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case fullName = "full_name"
        case role
        case createdAt = "created_at"
        case teamId = "team_id"
        case position
        case birthDate = "birth_date"
        case profileImageURL = "profile_image_url"
    }
    
    init(
        id: String? = nil,
        email: String,
        fullName: String,
        role: UserRole? = nil,
        createdAt: Date = Date(),
        teamId: String? = nil,
        position: String? = nil,
        birthDate: Date? = nil,
        profileImageURL: String? = nil
    ) {
        self.id = id
        self.email = email
        self.fullName = fullName
        self.role = role
        self.createdAt = createdAt
        self.teamId = teamId
        self.position = position
        self.birthDate = birthDate
        self.profileImageURL = profileImageURL
    }
    
    // Firestore mapping
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "email": email,
            "full_name": fullName,
            "created_at": Timestamp(date: createdAt)
        ]
        
        if let role = role { dict["role"] = role.rawValue }
        if let teamId = teamId { dict["team_id"] = teamId }
        if let position = position { dict["position"] = position }
        if let birthDate = birthDate { dict["birth_date"] = Timestamp(date: birthDate) }
        if let profileImageURL = profileImageURL { dict["profile_image_url"] = profileImageURL }
        
        return dict
    }
    
    static func fromFirestore(_ document: DocumentSnapshot) -> User? {
        guard let data = document.data() else { return nil }
        
        let email = data["email"] as? String ?? ""
        let fullName = data["full_name"] as? String ?? ""
        let roleString = data["role"] as? String
        let role = roleString != nil ? UserRole(rawValue: roleString!) : nil
        let timestamp = data["created_at"] as? Timestamp
        let createdAt = timestamp?.dateValue() ?? Date()
        
        return User(
            id: document.documentID,
            email: email,
            fullName: fullName,
            role: role,
            createdAt: createdAt,
            teamId: data["team_id"] as? String,
            position: data["position"] as? String,
            birthDate: (data["birth_date"] as? Timestamp)?.dateValue(),
            profileImageURL: data["profile_image_url"] as? String
        )
    }
    
    /// User's initials for avatar display
    var initials: String {
        let names = fullName.split(separator: " ")
        if names.count >= 2 {
            return String(names[0].prefix(1) + names[1].prefix(1)).uppercased()
        }
        return String(fullName.prefix(2)).uppercased()
    }
}
