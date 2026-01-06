//
//  AIService.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 5.01.2026.
//

import Foundation

enum AIServiceError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(String)
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API endpoint"
        case .invalidResponse:
            return "Invalid response from server"
        case .serverError(let message):
            return "Server error: \(message)"
        case .networkError:
            return "Network error occurred"
        }
    }
}

class AIService {
    static let shared = AIService()
    
    // TODO: Replace with your actual Firebase Functions endpoint
    private let baseURL = "https://your-project.cloudfunctions.net"
    
    private init() {}
    
    // Generate training plan from health data
    func generateTrainingPlan(healthData: [HealthData], userId: String) async throws -> TrainingPlan {
        guard let url = URL(string: "\(baseURL)/generateTrainingPlan") else {
            throw AIServiceError.invalidURL
        }
        
        // Prepare request payload
        let payload: [String: Any] = [
            "user_id": userId,
            "health_data": healthData.map { $0.toAIPayload() }
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
            throw AIServiceError.invalidResponse
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        request.timeoutInterval = 30
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AIServiceError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                throw AIServiceError.serverError(errorMessage)
            }
            
            // Parse response
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let planData = json["plan"] as? String else {
                throw AIServiceError.invalidResponse
            }
            
            let weekNumber = json["week_number"] as? Int ?? 1
            
            return TrainingPlan(
                userId: userId,
                planData: planData,
                generatedAt: Date(),
                weekNumber: weekNumber
            )
            
        } catch let error as AIServiceError {
            throw error
        } catch {
            throw AIServiceError.networkError
        }
    }
    
    // Generate training plan from single day's data
    func generateTrainingPlan(from healthData: HealthData, userId: String) async throws -> TrainingPlan {
        return try await generateTrainingPlan(healthData: [healthData], userId: userId)
    }
}
