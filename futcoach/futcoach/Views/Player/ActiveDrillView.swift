//
//  ActiveDrillView.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 7.01.2026.
//

import SwiftUI

struct ActiveDrillView: View {
    let drill: Drill
    let onComplete: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var workoutLogService = WorkoutLogService.shared
    
    // Timer state
    @State private var elapsedSeconds: Int = 0
    @State private var isRunning = false
    @State private var timer: Timer?
    
    // Set/rep tracking
    @State private var currentSet: Int = 1
    @State private var completedReps: Int = 0
    
    // Completion state
    @State private var showLogSheet = false
    @State private var showExitConfirmation = false
    
    private var totalSets: Int { drill.sets ?? 1 }
    private var repsPerSet: Int { drill.reps ?? 0 }
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color.primaryGradientStart, Color.primaryGradientMiddle, Color.primaryGradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { showExitConfirmation = true }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Text(drill.name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Placeholder for balance
                    Color.clear.frame(width: 32, height: 32)
                }
                .padding()
                
                Spacer()
                
                // Main Content
                VStack(spacing: 40) {
                    // Timer Display
                    VStack(spacing: 8) {
                        Text(formatTime(elapsedSeconds))
                            .font(.system(size: 72, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .monospacedDigit()
                        
                        Text("Geçen Süre")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    // Set/Rep Counter (if applicable)
                    if drill.sets != nil || drill.reps != nil {
                        HStack(spacing: 40) {
                            if drill.sets != nil {
                                CounterView(
                                    value: currentSet,
                                    total: totalSets,
                                    label: "Set"
                                )
                            }
                            
                            if drill.reps != nil {
                                CounterView(
                                    value: completedReps,
                                    total: repsPerSet * totalSets,
                                    label: "Tekrar"
                                )
                            }
                        }
                    }
                    
                    // Target info
                    if drill.durationMinutes != nil {
                        HStack(spacing: 8) {
                            Image(systemName: "target")
                                .foregroundColor(.yellow)
                            
                            Text("Hedef: \(drill.durationMinutes!) dakika")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                    }
                }
                
                Spacer()
                
                // Controls
                VStack(spacing: 20) {
                    // Timer Controls
                    HStack(spacing: 30) {
                        // Reset Button
                        Button(action: resetTimer) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                        
                        // Play/Pause Button
                        Button(action: toggleTimer) {
                            Image(systemName: isRunning ? "pause.fill" : "play.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.black)
                                .frame(width: 80, height: 80)
                                .background(
                                    Circle()
                                        .fill(.white)
                                        .shadow(color: .white.opacity(0.5), radius: 20)
                                )
                        }
                        
                        // Set Complete Button (if sets exist)
                        if drill.sets != nil {
                            Button(action: completeSet) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 24))
                                    .foregroundColor(.green)
                                    .frame(width: 60, height: 60)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Circle())
                            }
                        } else {
                            Color.clear.frame(width: 60, height: 60)
                        }
                    }
                    
                    // Complete Button
                    Button(action: {
                        stopTimer()
                        showLogSheet = true
                    }) {
                        Text("Antrenmanı Tamamla")
                            .font(.system(size: 18, weight: .bold))
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
                    .padding(.horizontal)
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
        .sheet(isPresented: $showLogSheet) {
            DrillLogView(
                drill: drill,
                durationSeconds: elapsedSeconds,
                sets: currentSet - 1,
                reps: completedReps
            ) {
                showLogSheet = false
                onComplete()
            }
        }
        .alert("Antrenmanı Sonlandır?", isPresented: $showExitConfirmation) {
            Button("İptal", role: .cancel) { }
            Button("Kaydetmeden Çık", role: .destructive) {
                stopTimer()
                dismiss()
            }
            Button("Kaydet ve Çık") {
                stopTimer()
                showLogSheet = true
            }
        } message: {
            Text("Antrenman kaydedilmeden çıkmak istediğinize emin misiniz?")
        }
    }
    
    // MARK: - Timer Methods
    
    private func startTimer() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            elapsedSeconds += 1
        }
    }
    
    private func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    private func toggleTimer() {
        if isRunning {
            stopTimer()
        } else {
            startTimer()
        }
        HapticManager.lightImpact()
    }
    
    private func resetTimer() {
        elapsedSeconds = 0
        currentSet = 1
        completedReps = 0
        HapticManager.lightImpact()
    }
    
    private func completeSet() {
        if currentSet < totalSets {
            currentSet += 1
            completedReps += repsPerSet
            HapticManager.success()
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

// MARK: - Counter View

struct CounterView: View {
    let value: Int
    let total: Int
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text("\(value)/\(total)")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(width: 100)
        .padding(.vertical, 20)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
}

#Preview {
    ActiveDrillView(
        drill: Drill(
            name: "Nordic Hamstring",
            category: .warmupPrevention,
            targetType: .prevention,
            sets: 3,
            reps: 6
        )
    ) { }
}
