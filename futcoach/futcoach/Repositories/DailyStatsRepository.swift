//
//  DailyStatsRepository.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 5.01.2026.
//

import Foundation
import FirebaseFirestore

class DailyStatsRepository {
    private let db = FirebaseService.shared.firestore
    private let statsCollection = "daily_stats"
    
    // MARK: - Caching
    
    /// Cache entry for weekly stats with timestamp
    private struct WeeklyCacheEntry {
        let fetchedAt: Date
        let stats: [DailyStats]
        
        var isValid: Bool {
            // Cache valid for 5 minutes
            Date().timeIntervalSince(fetchedAt) < 300
        }
    }
    
    /// In-memory cache for weekly stats, keyed by userId
    private static var weeklyCache: [String: WeeklyCacheEntry] = [:]
    
    /// Clear the cache for a specific user (call after sync)
    func invalidateWeeklyCache(userId: String) {
        Self.weeklyCache.removeValue(forKey: userId)
    }
    
    /// Clear all cached data
    static func clearAllCache() {
        weeklyCache.removeAll()
    }
    
    // MARK: - Weekly Stats
    
    /// Get weekly stats with caching - returns exactly 7 days with missing days filled
    func getWeeklyStatsCached(userId: String) async throws -> [DailyStats] {
        // Return cache if valid
        if let cached = Self.weeklyCache[userId], cached.isValid {
            return cached.stats
        }
        
        // Fetch fresh data
        let stats = try await getWeeklyStats(userId: userId)
        Self.weeklyCache[userId] = WeeklyCacheEntry(fetchedAt: Date(), stats: stats)
        return stats
    }
    
    /// Get the last 7 days of stats with missing days filled in
    func getWeeklyStats(userId: String) async throws -> [DailyStats] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        guard let sevenDaysAgo = calendar.date(byAdding: .day, value: -6, to: today) else {
            return []
        }
        
        // Fetch from Firestore
        let stats = try await getStatsRange(userId: userId, from: sevenDaysAgo, to: today)
        
        // Fill missing days with placeholder entries
        return fillMissingDays(stats, from: sevenDaysAgo, to: today, userId: userId)
    }
    
    /// Fill missing days in the stats array with zero/nil values
    private func fillMissingDays(_ stats: [DailyStats], from startDate: Date, to endDate: Date, userId: String) -> [DailyStats] {
        var result: [DailyStats] = []
        var calendar = Calendar.current
        calendar.timeZone = .current
        
        // Group existing stats by day for quick lookup
        let statsByDate = Dictionary(grouping: stats) {
            calendar.startOfDay(for: $0.date)
        }
        
        var currentDate = startDate
        while currentDate <= endDate {
            let dayStart = calendar.startOfDay(for: currentDate)
            
            if let existing = statsByDate[dayStart]?.first {
                // Use existing data
                result.append(existing)
            } else {
                // Create placeholder with zeros
                // Note: heartRate is nil (not 0) because 0 bpm is meaningless
                result.append(DailyStats(
                    userId: userId,
                    date: dayStart,
                    steps: 0,
                    distance: 0,
                    activeEnergy: 0,
                    heartRate: nil
                ))
            }
            
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDate
        }
        
        return result
    }
    
    // MARK: - Weekly Summary Calculations
    
    /// Calculate summary statistics for a week of data
    func calculateWeeklySummary(stats: [DailyStats], metric: HealthMetric) -> WeeklySummary {
        let values = stats.map { metric.value(from: $0) }
        let nonZeroValues = values.filter { $0 > 0 }
        
        let total = values.reduce(0, +)
        let average = nonZeroValues.isEmpty ? 0 : total / Double(nonZeroValues.count)
        
        // Find best day
        var bestDayIndex: Int? = nil
        var bestValue: Double = 0
        for (index, value) in values.enumerated() {
            if value > bestValue {
                bestValue = value
                bestDayIndex = index
            }
        }
        
        let bestDay = bestDayIndex.flatMap { stats.indices.contains($0) ? stats[$0].date : nil }
        
        return WeeklySummary(
            total: total,
            average: average,
            bestDay: bestDay,
            bestValue: bestValue,
            daysWithData: nonZeroValues.count
        )
    }
    
    // Save daily stats
    func saveDailyStats(_ stats: DailyStats) async throws {
        let docRef: DocumentReference
        
        if let id = stats.id {
            // Update existing document
            docRef = db.collection(statsCollection).document(id)
        } else {
            // Create new document
            docRef = db.collection(statsCollection).document()
        }
        
        try await docRef.setData(stats.toDictionary(), merge: true)
    }
    
    // Get daily stats for a specific date
    func getDailyStats(userId: String, date: Date) async throws -> DailyStats? {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? date
        
        let querySnapshot = try await db.collection(statsCollection)
            .whereField("user_id", isEqualTo: userId)
            .whereField("date", isGreaterThanOrEqualTo: Timestamp(date: startOfDay))
            .whereField("date", isLessThan: Timestamp(date: endOfDay))
            .limit(to: 1)
            .getDocuments()
        
        return querySnapshot.documents.first.flatMap { DailyStats.fromFirestore($0) }
    }
    
    // Get stats range for a user
    func getStatsRange(userId: String, from startDate: Date, to endDate: Date) async throws -> [DailyStats] {
        let querySnapshot = try await db.collection(statsCollection)
            .whereField("user_id", isEqualTo: userId)
            .whereField("date", isGreaterThanOrEqualTo: Timestamp(date: startDate))
            .whereField("date", isLessThanOrEqualTo: Timestamp(date: endDate))
            .order(by: "date", descending: true)
            .getDocuments()
        
        return querySnapshot.documents.compactMap { DailyStats.fromFirestore($0) }
    }
    
    // Get latest stats for user
    func getLatestStats(userId: String) async throws -> DailyStats? {
        let querySnapshot = try await db.collection(statsCollection)
            .whereField("user_id", isEqualTo: userId)
            .order(by: "date", descending: true)
            .limit(to: 1)
            .getDocuments()
        
        return querySnapshot.documents.first.flatMap { DailyStats.fromFirestore($0) }
    }
    
    // Get all stats for a player (used by coaches)
    func getAllStatsForPlayer(userId: String, limit: Int = 30) async throws -> [DailyStats] {
        let querySnapshot = try await db.collection(statsCollection)
            .whereField("user_id", isEqualTo: userId)
            .order(by: "date", descending: true)
            .limit(to: limit)
            .getDocuments()
        
        return querySnapshot.documents.compactMap { DailyStats.fromFirestore($0) }
    }
}
