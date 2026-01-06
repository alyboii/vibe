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
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case fullName = "full_name"
        case role
        case createdAt = "created_at"
    }
    
    init(id: String? = nil, email: String, fullName: String, role: UserRole? = nil, createdAt: Date = Date()) {
        self.id = id
        self.email = email
        self.fullName = fullName
        self.role = role
        self.createdAt = createdAt
    }
    
    // Firestore mapping
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "email": email,
            "full_name": fullName,
            "created_at": Timestamp(date: createdAt)
        ]
        
        if let role = role {
            dict["role"] = role.rawValue
        }
        
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
            createdAt: createdAt
        )
    }
}
