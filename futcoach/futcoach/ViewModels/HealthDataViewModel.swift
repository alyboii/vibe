//
//  HealthDataViewModel.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 5.01.2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class HealthDataViewModel: ObservableObject {
    @Published var steps: String = ""
    @Published var distance: String = ""
    @Published var activeEnergy: String = ""
    @Published var heartRate: String = ""
    @Published var selectedDate: Date = Date()
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    private let statsRepository = DailyStatsRepository()
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    // Save manual entry
    func saveManualEntry() async {
        guard let stepsValue = Int(steps), stepsValue >= 0 else {
            errorMessage = "Please enter valid steps"
            return
        }
        
        guard let distanceValue = Double(distance), distanceValue >= 0 else {
            errorMessage = "Please enter valid distance"
            return
        }
        
        guard let energyValue = Double(activeEnergy), energyValue >= 0 else {
            errorMessage = "Please enter valid active energy"
            return
        }
        
        let heartRateValue: Double? = heartRate.isEmpty ? nil : Double(heartRate)
        
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        do {
            let stats = DailyStats(
                userId: userId,
                date: selectedDate,
                steps: stepsValue,
                distance: distanceValue,
                activeEnergy: energyValue,
                heartRate: heartRateValue
            )
            
            try await statsRepository.saveDailyStats(stats)
            
            successMessage = "Health data saved successfully!"
            
            // Clear form
            clearForm()
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // Clear form
    func clearForm() {
        steps = ""
        distance = ""
        activeEnergy = ""
        heartRate = ""
        selectedDate = Date()
    }
    
    // Clear messages
    func clearMessages() {
        errorMessage = nil
        successMessage = nil
    }
}
