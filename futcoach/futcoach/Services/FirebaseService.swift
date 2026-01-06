//
//  FirebaseService.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 5.01.2026.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class FirebaseService {
    static let shared = FirebaseService()
    
    let auth: Auth
    let firestore: Firestore
    
    private init() {
        // Firebase is initialized in App
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
    }
    
    // Configure Firebase (called from App)
    static func configure() {
        FirebaseApp.configure()
    }
}
