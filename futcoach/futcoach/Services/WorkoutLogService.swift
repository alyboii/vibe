//
//  WorkoutLogService.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 7.01.2026.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

@MainActor
class WorkoutLogService: ObservableObject {
    static let shared = WorkoutLogService()
    
    private let db = Firestore.firestore()
    
    @Published var logs: [WorkoutLog] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private init() {}
    
    // MARK: - Log Workout
    
    /// Log a completed workout
    func logWorkout(
        drillId: String,
        drillName: String,
        drillCategory: DrillCategory,
        assignmentId: String? = nil,
        durationSeconds: Int? = nil,
        metrics: LogMetrics = LogMetrics(),
        rpe: Int? = nil,
        fatigueLevel: Int? = nil,
        notes: String? = nil
    ) async throws -> WorkoutLog {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "WorkoutLogService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Lütfen giriş yapın"])
        }
        
        isLoading = true
        defer { isLoading = false }
        
        // Get user's team ID
        let userDoc = try await db.collection("users").document(userId).getDocument()
        let teamId = userDoc.data()?["team_id"] as? String
        
        let log = WorkoutLog(
            playerId: userId,
            teamId: teamId,
            drillId: drillId,
            drillName: drillName,
            drillCategory: drillCategory,
            assignmentId: assignmentId,
            timestamp: Date(),
            durationSeconds: durationSeconds,
            metrics: metrics,
            rpe: rpe,
            fatigueLevel: fatigueLevel,
            notes: notes
        )
        
        let docRef = try await db.collection("workout_logs").addDocument(data: log.toDictionary())
        
        var createdLog = log
        createdLog.id = docRef.documentID
        
        // If this was for an assignment, update assignment status
        if let assignmentId = assignmentId {
            try await updateAssignmentProgress(assignmentId: assignmentId)
        }
        
        logs.insert(createdLog, at: 0)
        return createdLog
    }
    
    // MARK: - Fetch Logs
    
    /// Get player's workout logs
    func getPlayerLogs(playerId: String? = nil, limit: Int = 50) async throws -> [WorkoutLog] {
        let userId = playerId ?? Auth.auth().currentUser?.uid
        guard let uid = userId else {
            throw NSError(domain: "WorkoutLogService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Lütfen giriş yapın"])
        }
        
        isLoading = true
        defer { isLoading = false }
        
        let snapshot = try await db.collection("workout_logs")
            .whereField("player_id", isEqualTo: uid)
            .order(by: "timestamp", descending: true)
            .limit(to: limit)
            .getDocuments()
        
        logs = snapshot.documents.compactMap { WorkoutLog.fromFirestore($0) }
        return logs
    }
    
    /// Get logs within date range
    func getLogsInRange(playerId: String, startDate: Date, endDate: Date) async throws -> [WorkoutLog] {
        let snapshot = try await db.collection("workout_logs")
            .whereField("player_id", isEqualTo: playerId)
            .whereField("timestamp", isGreaterThanOrEqualTo: Timestamp(date: startDate))
            .whereField("timestamp", isLessThanOrEqualTo: Timestamp(date: endDate))
            .order(by: "timestamp", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { WorkoutLog.fromFirestore($0) }
    }
    
    /// Get logs for a specific drill
    func getLogsForDrill(playerId: String, drillId: String, limit: Int = 20) async throws -> [WorkoutLog] {
        let snapshot = try await db.collection("workout_logs")
            .whereField("player_id", isEqualTo: playerId)
            .whereField("drill_id", isEqualTo: drillId)
            .order(by: "timestamp", descending: true)
            .limit(to: limit)
            .getDocuments()
        
        return snapshot.documents.compactMap { WorkoutLog.fromFirestore($0) }
    }
    
    /// Get logs by category
    func getLogsByCategory(playerId: String, category: DrillCategory, limit: Int = 30) async throws -> [WorkoutLog] {
        let snapshot = try await db.collection("workout_logs")
            .whereField("player_id", isEqualTo: playerId)
            .whereField("drill_category", isEqualTo: category.rawValue)
            .order(by: "timestamp", descending: true)
            .limit(to: limit)
            .getDocuments()
        
        return snapshot.documents.compactMap { WorkoutLog.fromFirestore($0) }
    }
    
    // MARK: - Statistics
    
    /// Get weekly summary stats
    func getWeeklyStats(playerId: String) async throws -> WeeklyWorkoutStats {
        let calendar = Calendar.current
        let now = Date()
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
        let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart)!
        
        let logs = try await getLogsInRange(playerId: playerId, startDate: weekStart, endDate: weekEnd)
        
        return WeeklyWorkoutStats(
            totalWorkouts: logs.count,
            totalDurationMinutes: logs.totalDurationMinutes,
            averageRPE: logs.averageRPE,
            categoryBreakdown: logs.groupedByCategory.mapValues { $0.count },
            workoutDays: Set(logs.map { calendar.startOfDay(for: $0.timestamp) }).count
        )
    }
    
    /// Get shooting accuracy trend
    func getShootingAccuracyTrend(playerId: String, days: Int = 30) async throws -> [AccuracyDataPoint] {
        let startDate = Calendar.current.date(byAdding: .day, value: -days, to: Date())!
        let logs = try await getLogsInRange(playerId: playerId, startDate: startDate, endDate: Date())
        
        let shootingLogs = logs.filter { $0.drillCategory == .technicalShooting }
        
        return shootingLogs.compactMap { log -> AccuracyDataPoint? in
            guard let accuracy = log.metrics.accuracyPercentage else { return nil }
            return AccuracyDataPoint(date: log.timestamp, accuracy: accuracy)
        }
    }
    
    // MARK: - Private Helpers
    
    private func updateAssignmentProgress(assignmentId: String) async throws {
        // Mark assignment as completed
        try await db.collection("assignments").document(assignmentId).updateData([
            "status": AssignmentStatus.completed.rawValue,
            "completed_at": Timestamp(date: Date())
        ])
    }
}

// MARK: - Supporting Types

struct WeeklyWorkoutStats {
    let totalWorkouts: Int
    let totalDurationMinutes: Int
    let averageRPE: Double?
    let categoryBreakdown: [DrillCategory: Int]
    let workoutDays: Int
    
    var streakDays: Int { workoutDays }
}

struct AccuracyDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let accuracy: Double
}
