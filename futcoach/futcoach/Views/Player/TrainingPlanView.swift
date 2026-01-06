//
//  TrainingPlanView.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 5.01.2026.
//

import SwiftUI

struct TrainingPlanView: View {
    let userId: String
    @StateObject private var viewModel: PlayerDashboardViewModel
    
    init(userId: String) {
        self.userId = userId
        _viewModel = StateObject(wrappedValue: PlayerDashboardViewModel(userId: userId))
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.primaryGradientStart, Color.primaryGradientMiddle, Color.primaryGradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .dismissKeyboardOnTap()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Training Plan")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("AI-powered personalized training")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // Training Plan Content
                    if let plan = viewModel.trainingPlan {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Week \(plan.weekNumber)")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Text(plan.generatedAt.formatted(style: .medium))
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            
                            Divider()
                                .background(.white.opacity(0.3))
                            
                            Text(plan.planData)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .lineSpacing(4)
                        }
                        .padding(20)
                        .cardStyle()
                        .padding(.horizontal)
                    } else {
                        VStack(spacing: 20) {
                            Image(systemName: "figure.run.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.3))
                            
                            Text("No training plan yet")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("Generate a personalized plan based on your health data")
                                .font(.system(size: 15))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        .padding(.vertical, 60)
                    }
                    
                    // Error Message
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 14))
                            .foregroundColor(.red.opacity(0.9))
                            .padding()
                            .background(.white.opacity(0.1))
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    
                    // Generate Button
                    Button(action: {
                        Task {
                            await viewModel.generateTrainingPlan()
                        }
                    }) {
                        HStack(spacing: 12) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 18, weight: .bold))
                                Text("Generate New Plan")
                                    .font(.system(size: 18, weight: .bold))
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [Color.accentGradientStart, Color.accentGradientEnd],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: Color.accentGradientStart.opacity(0.5), radius: 20, x: 0, y: 10)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .disabled(viewModel.isLoading)
                    
                    Spacer()
                }
            }
        }
        .task {
            await viewModel.loadDashboardData()
        }
    }
}

#Preview {
    TrainingPlanView(userId: "test-user-id")
}
