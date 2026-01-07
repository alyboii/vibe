//
//  AssignDrillView.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 7.01.2026.
//

import SwiftUI

struct AssignDrillView: View {
    let teamId: String
    let players: [User]
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var drillService = DrillService.shared
    @StateObject private var assignmentService = AssignmentService.shared
    
    // Selection state
    @State private var selectedDrill: Drill?
    @State private var selectedPlayers: Set<String> = []
    @State private var assignToAll = true
    
    // Target state
    @State private var targetValue: String = "10"
    @State private var targetType: String = "rep"
    @State private var successCriteria: String = ""
    @State private var dueDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    @State private var notes: String = ""
    
    // UI state
    @State private var currentStep = 1
    @State private var isLoading = false
    @State private var showSuccess = false
    @State private var errorMessage: String?
    
    private let targetTypes = [
        ("rep", "Tekrar"),
        ("set", "Set"),
        ("minute", "Dakika"),
        ("shot", "Şut"),
        ("completion", "Tamamlama")
    ]
    
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
                
                VStack(spacing: 0) {
                    // Step Indicator
                    StepIndicator(currentStep: currentStep, totalSteps: 3)
                        .padding()
                    
                    // Content
                    TabView(selection: $currentStep) {
                        // Step 1: Select Drill
                        drillSelectionView
                            .tag(1)
                        
                        // Step 2: Set Target
                        targetSettingView
                            .tag(2)
                        
                        // Step 3: Select Players
                        playerSelectionView
                            .tag(3)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .animation(.easeInOut, value: currentStep)
                    
                    // Navigation Buttons
                    HStack(spacing: 16) {
                        if currentStep > 1 {
                            Button(action: { currentStep -= 1 }) {
                                Text("Geri")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(12)
                            }
                        }
                        
                        Button(action: handleNextStep) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text(currentStep == 3 ? "Ata" : "İleri")
                                        .font(.system(size: 16, weight: .bold))
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                LinearGradient(
                                    colors: canProceed ? [Color.accentGradientStart, Color.accentGradientEnd] : [.gray.opacity(0.5)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                        }
                        .disabled(!canProceed || isLoading)
                    }
                    .padding()
                }
            }
            .navigationTitle("Antrenman Ata")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") { dismiss() }
                        .foregroundColor(.white)
                }
            }
        }
        .sheet(isPresented: $showSuccess) {
            AssignmentSuccessView {
                showSuccess = false
                dismiss()
            }
        }
    }
    
    // MARK: - Step 1: Drill Selection
    
    private var drillSelectionView: some View {
        VStack(spacing: 16) {
            Text("Drill Seç")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(DrillCategory.allCases, id: \.self) { category in
                        let categoryDrills = drillService.drills.filter { $0.category == category }
                        if !categoryDrills.isEmpty {
                            DisclosureGroup {
                                ForEach(categoryDrills) { drill in
                                    DrillSelectRow(drill: drill, isSelected: selectedDrill?.id == drill.id) {
                                        selectedDrill = drill
                                        HapticManager.lightImpact()
                                    }
                                }
                            } label: {
                                HStack {
                                    Image(systemName: category.icon)
                                        .foregroundColor(category.color)
                                    Text(category.displayName)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white)
                                }
                            }
                            .tint(.white)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
        }
        .task {
            if drillService.drills.isEmpty {
                try? await drillService.getDrills()
            }
        }
    }
    
    // MARK: - Step 2: Target Setting
    
    private var targetSettingView: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Hedef Belirle")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                
                if let drill = selectedDrill {
                    // Selected drill card
                    HStack(spacing: 12) {
                        Image(systemName: drill.category.icon)
                            .font(.system(size: 24))
                            .foregroundColor(drill.category.color)
                        
                        VStack(alignment: .leading) {
                            Text(drill.name)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text(drill.category.displayName)
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                }
                
                // Target Type
                VStack(alignment: .leading, spacing: 12) {
                    Text("Hedef Tipi")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(targetTypes, id: \.0) { type in
                                Button(action: { targetType = type.0 }) {
                                    Text(type.1)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(targetType == type.0 ? .white : .white.opacity(0.7))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(targetType == type.0 ? Color.accentGradientStart : .white.opacity(0.1))
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                }
                
                // Target Value
                VStack(alignment: .leading, spacing: 12) {
                    Text("Hedef Değer")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    TextField("", text: $targetValue)
                        .keyboardType(.numberPad)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
                
                // Success Criteria (for accuracy-based)
                if selectedDrill?.logFormat == .accuracyBased {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Başarı Kriteri (İsabet)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                        
                        TextField("Örn: 7", text: $successCriteria)
                            .keyboardType(.numberPad)
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                    }
                }
                
                // Due Date
                VStack(alignment: .leading, spacing: 12) {
                    Text("Son Tarih")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    DatePicker("", selection: $dueDate, in: Date()..., displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .tint(.accentGradientStart)
                        .colorScheme(.dark)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
                
                // Notes
                VStack(alignment: .leading, spacing: 12) {
                    Text("Not (Opsiyonel)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    TextEditor(text: $notes)
                        .frame(height: 80)
                        .scrollContentBackground(.hidden)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .foregroundColor(.white)
                }
            }
            .padding()
        }
    }
    
    // MARK: - Step 3: Player Selection
    
    private var playerSelectionView: some View {
        VStack(spacing: 16) {
            Text("Oyuncu Seç")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            // Assign to all toggle
            Toggle(isOn: $assignToAll) {
                HStack {
                    Image(systemName: "person.3.fill")
                        .foregroundColor(.blue)
                    Text("Tüm takıma ata")
                        .foregroundColor(.white)
                }
            }
            .tint(.accentGradientStart)
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            
            if !assignToAll {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(players) { player in
                            PlayerSelectRow(
                                player: player,
                                isSelected: selectedPlayers.contains(player.id ?? "")
                            ) {
                                if let id = player.id {
                                    if selectedPlayers.contains(id) {
                                        selectedPlayers.remove(id)
                                    } else {
                                        selectedPlayers.insert(id)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            
            Spacer()
        }
        .padding()
    }
    
    // MARK: - Helpers
    
    private var canProceed: Bool {
        switch currentStep {
        case 1: return selectedDrill != nil
        case 2: return !targetValue.isEmpty && Int(targetValue) != nil
        case 3: return assignToAll || !selectedPlayers.isEmpty
        default: return false
        }
    }
    
    private func handleNextStep() {
        if currentStep < 3 {
            currentStep += 1
        } else {
            createAssignment()
        }
    }
    
    private func createAssignment() {
        guard let drill = selectedDrill,
              let value = Int(targetValue) else { return }
        
        isLoading = true
        
        let target = AssignmentTarget(
            type: targetType,
            value: value,
            unit: targetTypes.first { $0.0 == targetType }?.1 ?? targetType,
            successCriteria: Int(successCriteria)
        )
        
        Task {
            do {
                if assignToAll {
                    _ = try await assignmentService.createTeamAssignment(
                        teamId: teamId,
                        drill: drill,
                        target: target,
                        dueDate: dueDate,
                        notes: notes.isEmpty ? nil : notes
                    )
                } else {
                    for playerId in selectedPlayers {
                        _ = try await assignmentService.createAssignment(
                            teamId: teamId,
                            playerId: playerId,
                            drill: drill,
                            target: target,
                            dueDate: dueDate,
                            notes: notes.isEmpty ? nil : notes
                        )
                    }
                }
                
                HapticManager.success()
                showSuccess = true
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
}

// MARK: - Step Indicator

struct StepIndicator: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...totalSteps, id: \.self) { step in
                Circle()
                    .fill(step <= currentStep ? Color.accentGradientStart : .white.opacity(0.3))
                    .frame(width: 10, height: 10)
                
                if step < totalSteps {
                    Rectangle()
                        .fill(step < currentStep ? Color.accentGradientStart : .white.opacity(0.3))
                        .frame(height: 2)
                }
            }
        }
        .frame(maxWidth: 150)
    }
}

// MARK: - Drill Select Row

struct DrillSelectRow: View {
    let drill: Drill
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(drill.name)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(isSelected ? .green.opacity(0.2) : .clear)
            .cornerRadius(8)
        }
    }
}

// MARK: - Player Select Row

struct PlayerSelectRow: View {
    let player: User
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 40, height: 40)
                    
                    Text(player.initials)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading) {
                    Text(player.fullName)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                    
                    if let position = player.position {
                        Text(position)
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22))
                    .foregroundColor(isSelected ? .green : .white.opacity(0.4))
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
        }
    }
}

// MARK: - Success View

struct AssignmentSuccessView: View {
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.primaryGradientStart, Color.primaryGradientMiddle, Color.primaryGradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.2))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.green)
                }
                
                VStack(spacing: 8) {
                    Text("Atama Tamamlandı!")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Oyuncular bilgilendirildi")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                Button(action: onDismiss) {
                    Text("Tamam")
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
                .padding()
            }
        }
    }
}

#Preview {
    AssignDrillView(teamId: "team1", players: [])
}
