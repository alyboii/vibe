//
//  WorkoutLog.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 7.01.2026.
//

import Foundation
import FirebaseFirestore

// MARK: - Log Metrics

struct LogMetrics: Codable {
    // Count-based
    var totalReps: Int?
    var successfulReps: Int?
    var failedReps: Int?
    
    // Accuracy-based
    var attempts: Int?
    var hits: Int?
    
    // Load-based
    var sets: Int?
    var repsPerSet: Int?
    var weight: Double?           // kg
    
    // Time-based
    var intervals: Int?
    var intervalDuration: Int?    // seconds
    
    // Distance
    var distanceMeters: Double?
    
    init(
        totalReps: Int? = nil,
        successfulReps: Int? = nil,
        failedReps: Int? = nil,
        attempts: Int? = nil,
        hits: Int? = nil,
        sets: Int? = nil,
        repsPerSet: Int? = nil,
        weight: Double? = nil,
        intervals: Int? = nil,
        intervalDuration: Int? = nil,
        distanceMeters: Double? = nil
    ) {
        self.totalReps = totalReps
        self.successfulReps = successfulReps
        self.failedReps = failedReps
        self.attempts = attempts
        self.hits = hits
        self.sets = sets
        self.repsPerSet = repsPerSet
        self.weight = weight
        self.intervals = intervals
        self.intervalDuration = intervalDuration
        self.distanceMeters = distanceMeters
    }
    
    /// Accuracy percentage for shooting/passing drills
    var accuracyPercentage: Double? {
        guard let attempts = attempts, let hits = hits, attempts > 0 else { return nil }
        return Double(hits) / Double(attempts) * 100
    }
    
    /// Success rate for count-based drills
    var successRate: Double? {
        guard let total = totalReps, let successful = successfulReps, total > 0 else { return nil }
        return Double(successful) / Double(total) * 100
    }
    
    /// Total volume for load-based drills (sets x reps)
    var totalVolume: Int? {
        guard let sets = sets, let reps = repsPerSet else { return nil }
        return sets * reps
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        if let totalReps = totalReps { dict["total_reps"] = totalReps }
        if let successfulReps = successfulReps { dict["successful_reps"] = successfulReps }
        if let failedReps = failedReps { dict["failed_reps"] = failedReps }
        if let attempts = attempts { dict["attempts"] = attempts }
        if let hits = hits { dict["hits"] = hits }
        if let sets = sets { dict["sets"] = sets }
        if let repsPerSet = repsPerSet { dict["reps_per_set"] = repsPerSet }
        if let weight = weight { dict["weight"] = weight }
        if let intervals = intervals { dict["intervals"] = intervals }
        if let intervalDuration = intervalDuration { dict["interval_duration"] = intervalDuration }
        if let distanceMeters = distanceMeters { dict["distance_meters"] = distanceMeters }
        
        return dict
    }
    
    static func fromDictionary(_ data: [String: Any]) -> LogMetrics {
        return LogMetrics(
            totalReps: data["total_reps"] as? Int,
            successfulReps: data["successful_reps"] as? Int,
            failedReps: data["failed_reps"] as? Int,
            attempts: data["attempts"] as? Int,
            hits: data["hits"] as? Int,
            sets: data["sets"] as? Int,
            repsPerSet: data["reps_per_set"] as? Int,
            weight: data["weight"] as? Double,
            intervals: data["intervals"] as? Int,
            intervalDuration: data["interval_duration"] as? Int,
            distanceMeters: data["distance_meters"] as? Double
        )
    }
}

// MARK: - Workout Log Model

struct WorkoutLog: Identifiable, Codable {
    @DocumentID var id: String?
    let playerId: String
    let teamId: String?           // Hangi takımda yapıldı
    let drillId: String
    let drillName: String         // Denormalized
    let drillCategory: DrillCategory
    let assignmentId: String?     // Atamaya bağlıysa
    let timestamp: Date
    let durationSeconds: Int?
    let metrics: LogMetrics
    let rpe: Int?                 // 1-10 zorluk (Rate of Perceived Exertion)
    let fatigueLevel: Int?        // 1-10 yorgunluk
    let notes: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case playerId = "player_id"
        case teamId = "team_id"
        case drillId = "drill_id"
        case drillName = "drill_name"
        case drillCategory = "drill_category"
        case assignmentId = "assignment_id"
        case timestamp
        case durationSeconds = "duration_seconds"
        case metrics
        case rpe
        case fatigueLevel = "fatigue_level"
        case notes
    }
    
    init(
        id: String? = nil,
        playerId: String,
        teamId: String? = nil,
        drillId: String,
        drillName: String,
        drillCategory: DrillCategory,
        assignmentId: String? = nil,
        timestamp: Date = Date(),
        durationSeconds: Int? = nil,
        metrics: LogMetrics = LogMetrics(),
        rpe: Int? = nil,
        fatigueLevel: Int? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.playerId = playerId
        self.teamId = teamId
        self.drillId = drillId
        self.drillName = drillName
        self.drillCategory = drillCategory
        self.assignmentId = assignmentId
        self.timestamp = timestamp
        self.durationSeconds = durationSeconds
        self.metrics = metrics
        self.rpe = rpe
        self.fatigueLevel = fatigueLevel
        self.notes = notes
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "player_id": playerId,
            "drill_id": drillId,
            "drill_name": drillName,
            "drill_category": drillCategory.rawValue,
            "timestamp": Timestamp(date: timestamp),
            "metrics": metrics.toDictionary()
        ]
        
        if let teamId = teamId { dict["team_id"] = teamId }
        if let assignmentId = assignmentId { dict["assignment_id"] = assignmentId }
        if let durationSeconds = durationSeconds { dict["duration_seconds"] = durationSeconds }
        if let rpe = rpe { dict["rpe"] = rpe }
        if let fatigueLevel = fatigueLevel { dict["fatigue_level"] = fatigueLevel }
        if let notes = notes { dict["notes"] = notes }
        
        return dict
    }
    
    static func fromFirestore(_ document: DocumentSnapshot) -> WorkoutLog? {
        guard let data = document.data() else { return nil }
        
        let categoryString = data["drill_category"] as? String ?? ""
        let category = DrillCategory(rawValue: categoryString) ?? .warmupPrevention
        
        let metricsData = data["metrics"] as? [String: Any] ?? [:]
        let metrics = LogMetrics.fromDictionary(metricsData)
        
        return WorkoutLog(
            id: document.documentID,
            playerId: data["player_id"] as? String ?? "",
            teamId: data["team_id"] as? String,
            drillId: data["drill_id"] as? String ?? "",
            drillName: data["drill_name"] as? String ?? "",
            drillCategory: category,
            assignmentId: data["assignment_id"] as? String,
            timestamp: (data["timestamp"] as? Timestamp)?.dateValue() ?? Date(),
            durationSeconds: data["duration_seconds"] as? Int,
            metrics: metrics,
            rpe: data["rpe"] as? Int,
            fatigueLevel: data["fatigue_level"] as? Int,
            notes: data["notes"] as? String
        )
    }
    
    /// Duration formatted as mm:ss
    var durationFormatted: String {
        guard let seconds = durationSeconds else { return "-" }
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%d:%02d", mins, secs)
    }
    
    /// Date formatted for display
    var dateDisplay: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "d MMM, HH:mm"
        return formatter.string(from: timestamp)
    }
    
    /// Summary string based on metrics
    var metricsSummary: String {
        if let accuracy = metrics.accuracyPercentage {
            return String(format: "%.0f%% isabet", accuracy)
        }
        if let volume = metrics.totalVolume {
            if let weight = metrics.weight {
                return "\(volume) tekrar @ \(Int(weight))kg"
            }
            return "\(volume) tekrar"
        }
        if let totalReps = metrics.totalReps {
            return "\(totalReps) tekrar"
        }
        if let intervals = metrics.intervals {
            return "\(intervals) interval"
        }
        return durationFormatted
    }
}

// MARK: - Workout Log Extensions for Statistics

extension Array where Element == WorkoutLog {
    
    /// Total workout duration in minutes
    var totalDurationMinutes: Int {
        let totalSeconds = compactMap { $0.durationSeconds }.reduce(0, +)
        return totalSeconds / 60
    }
    
    /// Average RPE
    var averageRPE: Double? {
        let rpeValues = compactMap { $0.rpe }
        guard !rpeValues.isEmpty else { return nil }
        return Double(rpeValues.reduce(0, +)) / Double(rpeValues.count)
    }
    
    /// Logs grouped by category
    var groupedByCategory: [DrillCategory: [WorkoutLog]] {
        Dictionary(grouping: self) { $0.drillCategory }
    }
    
    /// Logs for last N days
    func logsForLast(days: Int) -> [WorkoutLog] {
        let cutoff = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        return filter { $0.timestamp >= cutoff }
    }
}
