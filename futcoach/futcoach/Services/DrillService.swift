//
//  DrillService.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 7.01.2026.
//

import Foundation
import Combine
import FirebaseFirestore

@MainActor
class DrillService: ObservableObject {
    static let shared = DrillService()
    
    private let db = Firestore.firestore()
    
    @Published var drills: [Drill] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cachedDrills: [Drill] = []
    
    private init() {}
    
    // MARK: - Fetch Methods
    
    /// Get all drills, optionally filtered by category and/or level
    func getDrills(category: DrillCategory? = nil, level: DrillLevel? = nil) async throws -> [Drill] {
        // Return cached if available
        if !cachedDrills.isEmpty {
            return filterDrills(cachedDrills, category: category, level: level)
        }
        
        isLoading = true
        defer { isLoading = false }
        
        let snapshot = try await db.collection("drills")
            .order(by: "order")
            .getDocuments()
        
        cachedDrills = snapshot.documents.compactMap { Drill.fromFirestore($0) }
        drills = filterDrills(cachedDrills, category: category, level: level)
        
        return drills
    }
    
    /// Get single drill by ID
    func getDrill(id: String) async throws -> Drill? {
        // Check cache first
        if let cached = cachedDrills.first(where: { $0.id == id }) {
            return cached
        }
        
        let doc = try await db.collection("drills").document(id).getDocument()
        return Drill.fromFirestore(doc)
    }
    
    /// Get drills by category
    func getDrillsByCategory(_ category: DrillCategory) async throws -> [Drill] {
        if !cachedDrills.isEmpty {
            return cachedDrills.filter { $0.category == category }
        }
        
        let snapshot = try await db.collection("drills")
            .whereField("category", isEqualTo: category.rawValue)
            .order(by: "order")
            .getDocuments()
        
        return snapshot.documents.compactMap { Drill.fromFirestore($0) }
    }
    
    /// Search drills by name
    func searchDrills(query: String) -> [Drill] {
        let lowercased = query.lowercased()
        return cachedDrills.filter {
            $0.name.lowercased().contains(lowercased) ||
            $0.nameEN.lowercased().contains(lowercased)
        }
    }
    
    /// Get featured/recommended drills
    func getFeaturedDrills() async throws -> [Drill] {
        if cachedDrills.isEmpty {
            _ = try await getDrills()
        }
        
        // Return first 3 from each category
        var featured: [Drill] = []
        for category in DrillCategory.allCases {
            let categoryDrills = cachedDrills.filter { $0.category == category }.prefix(3)
            featured.append(contentsOf: categoryDrills)
        }
        return featured
    }
    
    // MARK: - Private Helpers
    
    private func filterDrills(_ drills: [Drill], category: DrillCategory?, level: DrillLevel?) -> [Drill] {
        var filtered = drills
        
        if let category = category {
            filtered = filtered.filter { $0.category == category }
        }
        
        if let level = level {
            filtered = filtered.filter { $0.level == level }
        }
        
        return filtered
    }
    
    // MARK: - Seed Data (Development Only)
    
    /// Seed the database with drill data
    func seedDrills() async throws {
        let seeder = DrillSeeder()
        let drillsToSeed = seeder.getAllDrills()
        
        let batch = db.batch()
        
        for drill in drillsToSeed {
            let docRef = db.collection("drills").document()
            batch.setData(drill.toDictionary(), forDocument: docRef)
        }
        
        try await batch.commit()
        
        // Refresh cache
        cachedDrills = []
        _ = try await getDrills()
    }
    
    /// Check if drills are already seeded
    func isDrillsSeeded() async throws -> Bool {
        let snapshot = try await db.collection("drills").limit(to: 1).getDocuments()
        return !snapshot.documents.isEmpty
    }
}
