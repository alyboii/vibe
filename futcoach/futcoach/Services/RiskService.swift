//
//  RiskService.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 7.01.2026.
//

import Foundation
import SwiftUI
import Combine

// MARK: - Risk Warning Types

enum WarningType: String, Codable {
    case loadSpike = "load_spike"
    case missingPrevention = "missing_prevention"
    case highFatigue = "high_fatigue"
    case overtraining = "overtraining"
    case noWarmup = "no_warmup"
}

enum WarningSeverity: String, Codable {
    case info
    case warning
    case critical
    
    var color: Color {
        switch self {
        case .info: return .blue
        case .warning: return .orange
        case .critical: return .red
        }
    }
    
    var icon: String {
        switch self {
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .critical: return "exclamationmark.octagon.fill"
        }
    }
}

struct RiskWarning: Identifiable {
    let id = UUID()
    let type: WarningType
    let title: String
    let message: String
    let severity: WarningSeverity
    let recommendation: String
}

// MARK: - Risk Service

@MainActor
class RiskService: ObservableObject {
    static let shared = RiskService()
    
    @Published var warnings: [RiskWarning] = []
    @Published var isLoading = false
    
    private let workoutLogService = WorkoutLogService.shared
    
    private init() {}
    
    // MARK: - Check Risk Warnings
    
    /// Analyze player's logs and generate risk warnings
    func checkRiskWarnings(playerId: String) async throws -> [RiskWarning] {
        isLoading = true
        defer { isLoading = false }
        
        // Get last 14 days of logs
        let twoWeeksAgo = Calendar.current.date(byAdding: .day, value: -14, to: Date())!
        let logs = try await workoutLogService.getLogsInRange(
            playerId: playerId,
            startDate: twoWeeksAgo,
            endDate: Date()
        )
        
        var generatedWarnings: [RiskWarning] = []
        
        // 1. Load Spike Check
        if let loadWarning = checkLoadSpike(logs: logs) {
            generatedWarnings.append(loadWarning)
        }
        
        // 2. Missing Hamstring Prevention Check
        if let preventionWarning = checkMissingPrevention(logs: logs) {
            generatedWarnings.append(preventionWarning)
        }
        
        // 3. High Fatigue Check
        if let fatigueWarning = checkHighFatigue(logs: logs) {
            generatedWarnings.append(fatigueWarning)
        }
        
        // 4. Overtraining Check (7+ consecutive days)
        if let overtrainingWarning = checkOvertraining(logs: logs) {
            generatedWarnings.append(overtrainingWarning)
        }
        
        // 5. No Warmup Before Intense Work
        if let warmupWarning = checkNoWarmup(logs: logs) {
            generatedWarnings.append(warmupWarning)
        }
        
        warnings = generatedWarnings
        return generatedWarnings
    }
    
    // MARK: - Individual Checks
    
    /// Check if training volume increased by 40%+ compared to previous week
    private func checkLoadSpike(logs: [WorkoutLog]) -> RiskWarning? {
        let calendar = Calendar.current
        let now = Date()
        
        // This week
        let thisWeekStart = calendar.date(byAdding: .day, value: -7, to: now)!
        let thisWeekLogs = logs.filter { $0.timestamp >= thisWeekStart }
        let thisWeekMinutes = thisWeekLogs.totalDurationMinutes
        
        // Last week
        let lastWeekStart = calendar.date(byAdding: .day, value: -14, to: now)!
        let lastWeekLogs = logs.filter { $0.timestamp >= lastWeekStart && $0.timestamp < thisWeekStart }
        let lastWeekMinutes = lastWeekLogs.totalDurationMinutes
        
        // Check for spike
        if lastWeekMinutes > 0 {
            let increase = Double(thisWeekMinutes - lastWeekMinutes) / Double(lastWeekMinutes)
            if increase >= 0.4 {
                let percentIncrease = Int(increase * 100)
                return RiskWarning(
                    type: .loadSpike,
                    title: "Yük Artışı Uyarısı",
                    message: "Bu haftaki antrenman hacminiz geçen haftaya göre %\(percentIncrease) arttı.",
                    severity: .warning,
                    recommendation: "Ani yük artışları sakatlık riskini artırabilir. Yükü kademeli artırmayı düşünün."
                )
            }
        }
        
        return nil
    }
    
    /// Check if hamstring/prevention work is missing in last 14 days
    private func checkMissingPrevention(logs: [WorkoutLog]) -> RiskWarning? {
        let preventionWorkKeywords = ["Nordic", "Hamstring", "Glute", "Prevention", "Önleme"]
        
        let hasPreventionWork = logs.contains { log in
            preventionWorkKeywords.contains { keyword in
                log.drillName.localizedCaseInsensitiveContains(keyword)
            }
        }
        
        if !hasPreventionWork && logs.count >= 5 {
            return RiskWarning(
                type: .missingPrevention,
                title: "Sakatlık Önleme Eksik",
                message: "Son 14 günde hamstring/sakatlık önleme çalışması yapılmamış.",
                severity: .info,
                recommendation: "Haftada en az 2 kez Nordic hamstring veya sakatlık önleme drilleri ekleyin."
            )
        }
        
        return nil
    }
    
    /// Check if 3+ consecutive days have high RPE (8+)
    private func checkHighFatigue(logs: [WorkoutLog]) -> RiskWarning? {
        let sortedLogs = logs.sorted { $0.timestamp > $1.timestamp }
        let calendar = Calendar.current
        
        // Group logs by day
        var dailyMaxRPE: [Date: Int] = [:]
        for log in sortedLogs {
            let day = calendar.startOfDay(for: log.timestamp)
            if let rpe = log.rpe {
                dailyMaxRPE[day] = max(dailyMaxRPE[day] ?? 0, rpe)
            }
        }
        
        // Check last 3 days
        var consecutiveHighRPE = 0
        for dayOffset in 0..<3 {
            let day = calendar.date(byAdding: .day, value: -dayOffset, to: calendar.startOfDay(for: Date()))!
            if let rpe = dailyMaxRPE[day], rpe >= 8 {
                consecutiveHighRPE += 1
            }
        }
        
        if consecutiveHighRPE >= 3 {
            return RiskWarning(
                type: .highFatigue,
                title: "Yüksek Yorgunluk",
                message: "Son 3 gündür yüksek efor (RPE 8+) bildirdiniz.",
                severity: .warning,
                recommendation: "Aktif bir dinlenme günü planlamanız önerilir. Hafif mobilite veya yürüyüş tercih edin."
            )
        }
        
        return nil
    }
    
    /// Check if training 7+ consecutive days without rest
    private func checkOvertraining(logs: [WorkoutLog]) -> RiskWarning? {
        let calendar = Calendar.current
        
        // Get unique training days
        let trainingDays = Set(logs.map { calendar.startOfDay(for: $0.timestamp) })
        
        // Check for 7+ consecutive days
        var consecutiveDays = 0
        var maxConsecutive = 0
        
        for dayOffset in 0..<14 {
            let day = calendar.date(byAdding: .day, value: -dayOffset, to: calendar.startOfDay(for: Date()))!
            if trainingDays.contains(day) {
                consecutiveDays += 1
                maxConsecutive = max(maxConsecutive, consecutiveDays)
            } else {
                consecutiveDays = 0
            }
        }
        
        if maxConsecutive >= 7 {
            return RiskWarning(
                type: .overtraining,
                title: "Aşırı Antrenman Riski",
                message: "Son \(maxConsecutive) gün üst üste antrenman yaptınız.",
                severity: .critical,
                recommendation: "Vücudunuzun dinlenmesi gerekiyor. Haftada en az 1-2 dinlenme günü bırakın."
            )
        }
        
        return nil
    }
    
    /// Check if intense drills were done without warmup
    private func checkNoWarmup(logs: [WorkoutLog]) -> RiskWarning? {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Get today's logs
        let todayLogs = logs.filter { calendar.startOfDay(for: $0.timestamp) == today }
        
        if todayLogs.isEmpty { return nil }
        
        // Sort by time
        let sortedToday = todayLogs.sorted { $0.timestamp < $1.timestamp }
        
        // Check if first activity was warmup
        let firstLog = sortedToday.first!
        let isFirstWarmup = firstLog.drillCategory == .warmupPrevention
        
        // Check if there's intense work (shooting, speed, strength) without prior warmup
        let hasIntenseWork = todayLogs.contains { log in
            [.technicalShooting, .speedAgility, .strengthPlyometrics, .conditioning].contains(log.drillCategory)
        }
        
        if hasIntenseWork && !isFirstWarmup && todayLogs.count > 1 {
            return RiskWarning(
                type: .noWarmup,
                title: "Isınma Eksik",
                message: "Bugün yoğun antrenmana ısınma yapmadan başladınız.",
                severity: .info,
                recommendation: "Sakatlık riskini azaltmak için her antrenman öncesi 10-15 dk ısınma yapın."
            )
        }
        
        return nil
    }
    
    // MARK: - Helpers
    
    /// Get risk summary for coach view
    func getRiskSummary(for warnings: [RiskWarning]) -> String {
        if warnings.isEmpty {
            return "✅ Risk yok"
        }
        
        let criticalCount = warnings.filter { $0.severity == .critical }.count
        let warningCount = warnings.filter { $0.severity == .warning }.count
        
        if criticalCount > 0 {
            return "🔴 \(criticalCount) kritik uyarı"
        } else if warningCount > 0 {
            return "🟠 \(warningCount) uyarı"
        } else {
            return "🔵 \(warnings.count) bilgi"
        }
    }
}
