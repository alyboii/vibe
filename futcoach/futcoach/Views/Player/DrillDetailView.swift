//
//  DrillDetailView.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 7.01.2026.
//

import SwiftUI

struct DrillDetailView: View {
    let drill: Drill
    @Environment(\.dismiss) private var dismiss
    @State private var showActiveDrill = false
    
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
                    VStack(alignment: .leading, spacing: 24) {
                        // Header Card
                        VStack(spacing: 16) {
                            // Icon
                            ZStack {
                                Circle()
                                    .fill(drill.category.color.opacity(0.2))
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: drill.category.icon)
                                    .font(.system(size: 36))
                                    .foregroundColor(drill.category.color)
                            }
                            
                            // Title
                            VStack(spacing: 8) {
                                Text(drill.name)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                
                                if !drill.nameEN.isEmpty {
                                    Text(drill.nameEN)
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.6))
                                }
                            }
                            
                            // Tags
                            HStack(spacing: 12) {
                                TagView(text: drill.category.displayName, color: drill.category.color)
                                TagView(text: drill.level.displayName, color: levelColor(drill.level))
                                if !drill.formatDisplay.isEmpty {
                                    TagView(text: drill.formatDisplay, color: .blue)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(24)
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        
                        // Description
                        if !drill.description.isEmpty {
                            SectionCard(title: "Açıklama", icon: "text.alignleft") {
                                Text(drill.description)
                                    .font(.system(size: 15))
                                    .foregroundColor(.white.opacity(0.9))
                                    .lineSpacing(4)
                            }
                        }
                        
                        // Equipment
                        if !drill.equipment.isEmpty {
                            SectionCard(title: "Ekipman", icon: "bag") {
                                HStack(spacing: 10) {
                                    ForEach(drill.equipment, id: \.self) { item in
                                        HStack(spacing: 6) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.system(size: 12))
                                                .foregroundColor(.green)
                                            
                                            Text(item)
                                                .font(.system(size: 14))
                                                .foregroundColor(.white)
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(.white.opacity(0.1))
                                        .cornerRadius(20)
                                    }
                                }
                            }
                        }
                        
                        // Coaching Tips
                        if !drill.coachingTips.isEmpty {
                            SectionCard(title: "Koçluk İpuçları", icon: "lightbulb") {
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(Array(drill.coachingTips.enumerated()), id: \.offset) { index, tip in
                                        HStack(alignment: .top, spacing: 12) {
                                            Text("\(index + 1)")
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundColor(.black)
                                                .frame(width: 24, height: 24)
                                                .background(Circle().fill(.yellow))
                                            
                                            Text(tip)
                                                .font(.system(size: 14))
                                                .foregroundColor(.white.opacity(0.9))
                                                .lineSpacing(2)
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Safety Notes
                        if let safetyNotes = drill.safetyNotes, !safetyNotes.isEmpty {
                            SectionCard(title: "Güvenlik Uyarısı", icon: "exclamationmark.triangle", iconColor: .orange) {
                                Text(safetyNotes)
                                    .font(.system(size: 14))
                                    .foregroundColor(.orange)
                                    .padding(12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.orange.opacity(0.15))
                                    .cornerRadius(12)
                            }
                        }
                        
                        // Log Format Info
                        SectionCard(title: "Kayıt Formatı", icon: "square.and.pencil") {
                            HStack(spacing: 10) {
                                Image(systemName: logFormatIcon(drill.logFormat))
                                    .font(.system(size: 16))
                                    .foregroundColor(.blue)
                                
                                Text(drill.logFormat.displayName)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.9))
                                
                                Spacer()
                                
                                Text(logFormatDescription(drill.logFormat))
                                    .font(.system(size: 12))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                        
                        // Spacer for button
                        Spacer().frame(height: 80)
                    }
                    .padding()
                }
                
                // Start Button
                VStack {
                    Spacer()
                    
                    Button(action: { showActiveDrill = true }) {
                        HStack(spacing: 12) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 18))
                            
                            Text("Antrenmanı Başlat")
                                .font(.system(size: 18, weight: .bold))
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
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.primaryGradientEnd.opacity(0), Color.primaryGradientEnd],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showActiveDrill) {
            ActiveDrillView(drill: drill) {
                showActiveDrill = false
                dismiss()
            }
        }
    }
    
    private func levelColor(_ level: DrillLevel) -> Color {
        switch level {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }
    
    private func logFormatIcon(_ format: LogFormat) -> String {
        switch format {
        case .countBased: return "number"
        case .timeBased: return "timer"
        case .loadBased: return "scalemass"
        case .accuracyBased: return "target"
        case .completionOnly: return "checkmark.circle"
        case .ratingOnly: return "star"
        }
    }
    
    private func logFormatDescription(_ format: LogFormat) -> String {
        switch format {
        case .countBased: return "Tekrar sayısı girilecek"
        case .timeBased: return "Süre kaydedilecek"
        case .loadBased: return "Set, tekrar, ağırlık"
        case .accuracyBased: return "İsabet oranı"
        case .completionOnly: return "Tamamlandı işareti"
        case .ratingOnly: return "Zorluk değerlendirmesi"
        }
    }
}

// MARK: - Tag View

struct TagView: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(color)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(0.2))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(color.opacity(0.5), lineWidth: 1)
            )
    }
}

// MARK: - Section Card

struct SectionCard<Content: View>: View {
    let title: String
    let icon: String
    var iconColor: Color = .white
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(iconColor.opacity(0.8))
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
}

#Preview {
    DrillDetailView(drill: Drill(
        name: "Nordic Hamstring",
        nameEN: "Nordic Hamstring Curl",
        category: .warmupPrevention,
        targetType: .prevention,
        equipment: ["Partner"],
        level: .intermediate,
        sets: 3,
        reps: 6,
        description: "Partner destekli eksantrik hamstring kuvvetlendirme",
        coachingTips: ["Yavaş iniş (3-4sn)", "Kalça düz kalmalı", "Ellerle yakalayın, itin ve tekrar"],
        safetyNotes: "Hamstring geçmişi varsa dikkatli başlayın",
        logFormat: .loadBased
    ))
}
