//
//  HealthKitManager.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 5.01.2026.
//

import Foundation
import HealthKit

enum HealthKitError: LocalizedError {
    case notAvailable
    case authorizationDenied
    case dataNotAvailable
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .notAvailable:
            return "HealthKit is not available on this device"
        case .authorizationDenied:
            return "HealthKit access was denied"
        case .dataNotAvailable:
            return "Health data is not available"
        case .unknown(let message):
            return message
        }
    }
}

class HealthKitManager {
    static let shared = HealthKitManager()
    
    private let healthStore = HKHealthStore()
    
    private init() {}
    
    // Check if HealthKit is available
    var isHealthKitAvailable: Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    // Request authorization
    func requestAuthorization() async throws {
        guard isHealthKitAvailable else {
            throw HealthKitError.notAvailable
        }
        
        let typesToRead: Set<HKObjectType> = [
            HKQuantityType.quantityType(forIdentifier: .stepCount)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .heartRate)!
        ]
        
        try await healthStore.requestAuthorization(toShare: [], read: typesToRead)
    }
    
    // Fetch daily stats for a specific date
    func fetchDailyStats(for date: Date) async throws -> HealthData {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? date
        
        async let steps = fetchSteps(from: startOfDay, to: endOfDay)
        async let distance = fetchDistance(from: startOfDay, to: endOfDay)
        async let activeEnergy = fetchActiveEnergy(from: startOfDay, to: endOfDay)
        async let heartRate = fetchAverageHeartRate(from: startOfDay, to: endOfDay)
        
        let stepsValue = try await steps
        let distanceValue = try await distance
        let activeEnergyValue = try await activeEnergy
        let heartRateValue = try? await heartRate // Optional, so use try?
        
        return HealthData(
            steps: Int(stepsValue),
            distance: distanceValue,
            activeEnergy: activeEnergyValue,
            heartRate: heartRateValue,
            date: date
        )
    }
    
    // Sync today's health data
    func syncHealthData() async throws -> HealthData {
        return try await fetchDailyStats(for: Date())
    }
    
    // MARK: - Private Helper Methods
    
    private func fetchSteps(from startDate: Date, to endDate: Date) async throws -> Double {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            throw HealthKitError.dataNotAvailable
        }
        
        return try await fetchQuantity(type: stepType, from: startDate, to: endDate, unit: .count())
    }
    
    private func fetchDistance(from startDate: Date, to endDate: Date) async throws -> Double {
        guard let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            throw HealthKitError.dataNotAvailable
        }
        
        return try await fetchQuantity(type: distanceType, from: startDate, to: endDate, unit: .meter())
    }
    
    private func fetchActiveEnergy(from startDate: Date, to endDate: Date) async throws -> Double {
        guard let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            throw HealthKitError.dataNotAvailable
        }
        
        return try await fetchQuantity(type: energyType, from: startDate, to: endDate, unit: .kilocalorie())
    }
    
    private func fetchAverageHeartRate(from startDate: Date, to endDate: Date) async throws -> Double {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            throw HealthKitError.dataNotAvailable
        }
        
        return try await fetchQuantity(type: heartRateType, from: startDate, to: endDate, unit: HKUnit.count().unitDivided(by: .minute()), useAverage: true)
    }
    
    private func fetchQuantity(type: HKQuantityType, from startDate: Date, to endDate: Date, unit: HKUnit, useAverage: Bool = false) async throws -> Double {
        return try await withCheckedThrowingContinuation { continuation in
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            
            let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: useAverage ? .discreteAverage : .cumulativeSum) { _, result, error in
                if let error = error {
                    continuation.resume(throwing: HealthKitError.unknown(error.localizedDescription))
                    return
                }
                
                guard let result = result else {
                    continuation.resume(returning: 0.0)
                    return
                }
                
                let value: Double
                if useAverage {
                    value = result.averageQuantity()?.doubleValue(for: unit) ?? 0.0
                } else {
                    value = result.sumQuantity()?.doubleValue(for: unit) ?? 0.0
                }
                
                continuation.resume(returning: value)
            }
            
            healthStore.execute(query)
        }
    }
}
