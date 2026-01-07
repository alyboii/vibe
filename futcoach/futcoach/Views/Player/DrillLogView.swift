//
//  DrillLogView.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 7.01.2026.
//

import SwiftUI

struct DrillLogView: View {
    let drill: Drill
    let durationSeconds: Int
    let sets: Int
    let reps: Int
    let onComplete: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var workoutLogService = WorkoutLogService.shared
    
    // Log fields
    @State private var totalReps: String = ""
    @State private var successfulReps: String = ""
    @State private var attempts: String = ""
    @State private var hits: String = ""
    @State private var weight: String = ""
    @State private var rpe: Int = 5
    @State private var fatigueLevel: Int = 5
    @State private var notes: String = ""
    
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    colors: [Color.primaryGradientStart, Color.primaryGradientMiddle, Color.primaryGradientEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Summary Card
                        VStack(spacing: 16) {
                            HStack(spacing: 16) {
                                StatBox(value: formatDuration(durationSeconds), label: "Süre")
                                
                                if sets > 0 {
                                    StatBox(value: "\(sets)", label: "Set")
                                }
                                
                                if reps > 0 {
                                    StatBox(value: "\(reps)", label: "Tekrar")
                                }
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                        
                        // Dynamic Log Form based on drill type
                        VStack(spacing: 20) {
                            switch drill.logFormat {
                            case .countBased:
                                LogInputField(title: "Toplam Tekrar", text: $totalReps, keyboardType: .numberPad)
                                LogInputField(title: "Başarılı Tekrar", text: $successfulReps, keyboardType: .numberPad)
                                
                            case .accuracyBased:
                                LogInputField(title: "Deneme Sayısı", text: $attempts, keyboardType: .numberPad)
                                LogInputField(title: "İsabet Sayısı", text: $hits, keyboardType: .numberPad)
                                
                                if let attempts = Int(attempts), let hits = Int(hits), attempts > 0 {
                                    HStack {
                                        Text("İsabet Oranı:")
                                            .foregroundColor(.white.opacity(0.7))
                                        Spacer()
                                        Text(String(format: "%.1f%%", Double(hits) / Double(attempts) * 100))
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.green)
                                    }
                                    .padding()
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(12)
                                }
                                
                            case .loadBased:
                                LogInputField(title: "Ağırlık (kg)", text: $weight, keyboardType: .decimalPad)
                                
                            case .timeBased, .completionOnly, .ratingOnly:
                                EmptyView()
                            }
                            
                            // RPE Slider
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Zorluk (RPE)")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Text("\(rpe)/10")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(rpeColor(rpe))
                                }
                                
                                Slider(value: Binding(
                                    get: { Double(rpe) },
                                    set: { rpe = Int($0) }
                                ), in: 1...10, step: 1)
                                .tint(rpeColor(rpe))
                                
                                HStack {
                                    Text("Kolay")
                                        .font(.system(size: 12))
                                        .foregroundColor(.green.opacity(0.8))
                                    Spacer()
                                    Text("Çok Zor")
                                        .font(.system(size: 12))
                                        .foregroundColor(.red.opacity(0.8))
                                }
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                            
                            // Fatigue Slider
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Yorgunluk")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Text("\(fatigueLevel)/10")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(fatigueColor(fatigueLevel))
                                }
                                
                                Slider(value: Binding(
                                    get: { Double(fatigueLevel) },
                                    set: { fatigueLevel = Int($0) }
                                ), in: 1...10, step: 1)
                                .tint(fatigueColor(fatigueLevel))
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                            
                            // Notes
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notlar (Opsiyonel)")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                
                                TextEditor(text: $notes)
                                    .frame(height: 80)
                                    .scrollContentBackground(.hidden)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(12)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Save Button
                        Button(action: saveLog) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Image(systemName: "checkmark.circle.fill")
                                    Text("Kaydet")
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
                        }
                        .disabled(isLoading)
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("Antrenman Kaydı")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .alert("Hata", isPresented: $showError) {
            Button("Tamam", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    // MARK: - Helpers
    
    private func formatDuration(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%d:%02d", mins, secs)
    }
    
    private func rpeColor(_ value: Int) -> Color {
        switch value {
        case 1...3: return .green
        case 4...6: return .yellow
        case 7...8: return .orange
        default: return .red
        }
    }
    
    private func fatigueColor(_ value: Int) -> Color {
        switch value {
        case 1...3: return .green
        case 4...6: return .yellow
        case 7...8: return .orange
        default: return .red
        }
    }
    
    private func saveLog() {
        isLoading = true
        
        Task {
            do {
                var metrics = LogMetrics()
                
                switch drill.logFormat {
                case .countBased:
                    metrics.totalReps = Int(totalReps)
                    metrics.successfulReps = Int(successfulReps)
                    
                case .accuracyBased:
                    metrics.attempts = Int(attempts)
                    metrics.hits = Int(hits)
                    
                case .loadBased:
                    metrics.sets = sets > 0 ? sets : drill.sets
                    metrics.repsPerSet = reps > 0 ? reps / max(sets, 1) : drill.reps
                    metrics.weight = Double(weight)
                    
                case .timeBased:
                    metrics.intervalDuration = durationSeconds
                    
                default:
                    break
                }
                
                _ = try await workoutLogService.logWorkout(
                    drillId: drill.id ?? "",
                    drillName: drill.name,
                    drillCategory: drill.category,
                    durationSeconds: durationSeconds,
                    metrics: metrics,
                    rpe: rpe,
                    fatigueLevel: fatigueLevel,
                    notes: notes.isEmpty ? nil : notes
                )
                
                HapticManager.success()
                onComplete()
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
            
            isLoading = false
        }
    }
}

// MARK: - Stat Box

struct StatBox: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Log Input Field

struct LogInputField: View {
    let title: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
            
            TextField("", text: $text)
                .keyboardType(keyboardType)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    DrillLogView(
        drill: Drill(
            name: "Spot Shooting",
            category: .technicalShooting,
            targetType: .technical,
            logFormat: .accuracyBased
        ),
        durationSeconds: 325,
        sets: 3,
        reps: 30
    ) { }
}
