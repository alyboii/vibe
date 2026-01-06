//
//  HealthDataEntryView.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇ AYIR on 5.01.2026.
//

import SwiftUI

struct HealthDataEntryView: View {
    let userId: String
    @StateObject private var viewModel: HealthDataViewModel
    
    init(userId: String) {
        self.userId = userId
        _viewModel = StateObject(wrappedValue: HealthDataViewModel(userId: userId))
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
                ZStack(alignment: .top) {
                    // Tap area to dismiss keyboard
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            hideKeyboard()
                        }
                    
                    VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Health Data")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Manually enter your daily stats")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // Date Picker
                    DatePicker("Date", selection: $viewModel.selectedDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .foregroundColor(.white)
                        .padding()
                        .cardStyle()
                        .padding(.horizontal)
                   
                    // Form Fields
                  VStack(spacing: 16) {
                        FormField(
                            icon: "figure.walk",
                            title: "Steps",
                            placeholder: "e.g. 10000",
                            text: $viewModel.steps,
                            keyboardType: .numberPad
                        )
                        
                        FormField(
                            icon: "location.fill",
                            title: "Distance (meters)",
                            placeholder: "e.g. 5000",
                            text: $viewModel.distance,
                            keyboardType: .decimalPad
                        )
                        
                        FormField(
                            icon: "flame.fill",
                            title: "Active Energy (kcal)",
                            placeholder: "e.g. 300",
                            text: $viewModel.activeEnergy,
                            keyboardType: .decimalPad
                        )
                        
                        FormField(
                            icon: "heart.fill",
                            title: "Heart Rate (optional)",
                            placeholder: "e.g. 75",
                            text: $viewModel.heartRate,
                            keyboardType: .decimalPad
                        )
                    }
                    .padding(.horizontal)
                    
                    // Success Message
                    if let successMessage = viewModel.successMessage {
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text(successMessage)
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(.green.opacity(0.2))
                        .cornerRadius(12)
                        .padding(.horizontal)
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
                    
                    // Save Button
                    Button(action: {
                        Task {
                            await viewModel.saveManualEntry()
                        }
                    }) {
                        HStack(spacing: 12) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Save Data")
                                    .font(.system(size: 18, weight: .bold))
                                Image(systemName: "checkmark.circle.fill")
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
        }
        .onDisappear {
            viewModel.clearMessages()
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct FormField: View {
    let icon: String
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.white.opacity(0.7))
                    .font(.system(size: 16))
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
            }
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .foregroundColor(.white)
                .padding()
                .background(.white.opacity(0.15))
                .cornerRadius(12)
        }
    }
}

#Preview {
    HealthDataEntryView(userId: "test-user-id")
}
