//
//  PlayerDashboardViewModel.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 5.01.2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class PlayerDashboardViewModel: ObservableObject {
    @Published var dailyStats: DailyStats?
    @Published var trainingPlan: TrainingPlan?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isSyncingHealthKit = false
    
    // MARK: - Weekly Progress Properties
    @Published var weeklyStats: [DailyStats] = []
    @Published var selectedMetric: HealthMetric = .steps
    @Published var isLoadingWeekly = false
    @Published var currentStreak: Int = 0
    
    private let statsRepository = DailyStatsRepository()
    private let healthKitManager = HealthKitManager.shared
    private let aiService = AIService.shared
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    // MARK: - Load Dashboard Data
    
    /// Load all dashboard data including weekly stats
    func loadDashboardData() async {
        isLoading = true
        errorMessage = nil
        
        // Load in parallel
        async let dailyTask: () = loadTodayStats()
        async let weeklyTask: () = loadWeeklyStats()
        
        await dailyTask
        await weeklyTask
        
        isLoading = false
    }
    
    /// Load today's stats only
    private func loadTodayStats() async {
        do {
            dailyStats = try await statsRepository.getDailyStats(userId: userId, date: Date())
        } catch {
            // Don't override error if weekly loaded fine
            if errorMessage == nil {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    /// Load weekly stats with caching
    func loadWeeklyStats() async {
        isLoadingWeekly = true
        
        do {
            weeklyStats = try await statsRepository.getWeeklyStatsCached(userId: userId)
            calculateStreak()
        } catch {
            if errorMessage == nil {
                errorMessage = error.localizedDescription
            }
        }
        
        isLoadingWeekly = false
    }
    
    /// Calculate current streak based on consecutive days with activity
    private func calculateStreak() {
        var streak = 0
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Sort by date descending (most recent first)
        let sortedStats = weeklyStats.sorted { $0.date > $1.date }
        
        for stat in sortedStats {
            let statDay = calendar.startOfDay(for: stat.date)
            let expectedDay = calendar.date(byAdding: .day, value: -streak, to: today)!
            
            // Check if this is the expected day in the streak
            if calendar.isDate(statDay, inSameDayAs: expectedDay) {
                // Has activity? (any non-zero value)
                if stat.steps > 0 || stat.distance > 0 || stat.activeEnergy > 0 {
                    streak += 1
                } else {
                    break // No activity on this day, streak broken
                }
            } else {
                break // Gap in days, streak broken
            }
        }
        
        currentStreak = streak
    }
    
    // Sync with HealthKit
    func syncHealthKit() async {
        guard healthKitManager.isHealthKitAvailable else {
            errorMessage = "HealthKit is not available on this device"
            return
        }
        
        isSyncingHealthKit = true
        errorMessage = nil
        
        do {
            // Request authorization first
            try await healthKitManager.requestAuthorization()
            
            // Fetch today's data
            let healthData = try await healthKitManager.syncHealthData()
            
            // Convert to DailyStats and save
            let stats = healthData.toDailyStats(userId: userId)
            try await statsRepository.saveDailyStats(stats)
            
            // Update local state
            dailyStats = stats
            
            // Invalidate cache and reload weekly stats
            statsRepository.invalidateWeeklyCache(userId: userId)
            await loadWeeklyStats()
            
            // Success haptic
            HapticManager.success()
            
        } catch {
            errorMessage = error.localizedDescription
            HapticManager.error()
        }
        
        isSyncingHealthKit = false
    }
    
    // Generate AI training plan
    func generateTrainingPlan() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Get recent stats (last 7 days)
            let endDate = Date()
            let startDate = Calendar.current.date(byAdding: .day, value: -7, to: endDate) ?? endDate
            let recentStats = try await statsRepository.getStatsRange(userId: userId, from: startDate, to: endDate)
            
            // Convert to HealthData array
            let healthDataArray = recentStats.map { stat in
                HealthData(
                    steps: stat.steps,
                    distance: stat.distance,
                    activeEnergy: stat.activeEnergy,
                    heartRate: stat.heartRate,
                    date: stat.date
                )
            }
            
            guard !healthDataArray.isEmpty else {
                errorMessage = "Not enough health data to generate a training plan"
                isLoading = false
                return
            }
            
            // Generate plan
            let plan = try await aiService.generateTrainingPlan(healthData: healthDataArray, userId: userId)
            trainingPlan = plan
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // Clear error
    func clearError() {
        errorMessage = nil
    }
}
