//
//  DrillLibraryView.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 7.01.2026.
//

import SwiftUI

struct DrillLibraryView: View {
    @StateObject private var drillService = DrillService.shared
    @State private var selectedCategory: DrillCategory?
    @State private var selectedLevel: DrillLevel?
    @State private var searchText = ""
    @State private var selectedDrill: Drill?
    @State private var showDrillDetail = false
    
    private var filteredDrills: [Drill] {
        var result = drillService.drills
        
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }
        
        if let level = selectedLevel {
            result = result.filter { $0.level == level }
        }
        
        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.nameEN.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result
    }
    
    private var groupedDrills: [DrillCategory: [Drill]] {
        Dictionary(grouping: filteredDrills) { $0.category }
    }
    
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
                VStack(alignment: .leading, spacing: 16) {
                    Text("Drill Kütüphanesi")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    // Search Bar
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white.opacity(0.6))
                        
                        TextField("Drill ara...", text: $searchText)
                            .foregroundColor(.white)
                            .placeholder(when: searchText.isEmpty) {
                                Text("Drill ara...")
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                    }
                    .padding(12)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    
                    // Category Filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            FilterChip(
                                title: "Tümü",
                                isSelected: selectedCategory == nil,
                                color: .white
                            ) {
                                withAnimation { selectedCategory = nil }
                            }
                            
                            ForEach(DrillCategory.allCases, id: \.self) { category in
                                FilterChip(
                                    title: category.displayName,
                                    icon: category.icon,
                                    isSelected: selectedCategory == category,
                                    color: category.color
                                ) {
                                    withAnimation {
                                        selectedCategory = selectedCategory == category ? nil : category
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
                
                // Drills List
                if drillService.isLoading {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                    Spacer()
                } else if filteredDrills.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(.white.opacity(0.3))
                        
                        Text("Drill bulunamadı")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16, pinnedViews: .sectionHeaders) {
                            if selectedCategory == nil {
                                // Grouped by category
                                ForEach(DrillCategory.allCases, id: \.self) { category in
                                    if let drills = groupedDrills[category], !drills.isEmpty {
                                        Section {
                                            ForEach(drills) { drill in
                                                DrillCard(drill: drill) {
                                                    selectedDrill = drill
                                                    showDrillDetail = true
                                                }
                                            }
                                        } header: {
                                            CategoryHeader(category: category)
                                        }
                                    }
                                }
                            } else {
                                // Flat list for selected category
                                ForEach(filteredDrills) { drill in
                                    DrillCard(drill: drill) {
                                        selectedDrill = drill
                                        showDrillDetail = true
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .task {
            if drillService.drills.isEmpty {
                do {
                    _ = try await drillService.getDrills()
                } catch {
                    print("Failed to load drills: \(error)")
                }
            }
        }
        .sheet(isPresented: $showDrillDetail) {
            if let drill = selectedDrill {
                DrillDetailView(drill: drill)
            }
        }
    }
}

// MARK: - Filter Chip

struct FilterChip: View {
    let title: String
    var icon: String? = nil
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 12))
                }
                
                Text(title)
                    .font(.system(size: 13, weight: .medium))
            }
            .foregroundColor(isSelected ? .white : color.opacity(0.9))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                isSelected ? color.opacity(0.8) : color.opacity(0.15)
            )
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? color : color.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

// MARK: - Category Header

struct CategoryHeader: View {
    let category: DrillCategory
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: category.icon)
                .font(.system(size: 16))
                .foregroundColor(category.color)
            
            Text(category.displayName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .background(
            LinearGradient(
                colors: [Color.primaryGradientMiddle.opacity(0.95), Color.primaryGradientMiddle.opacity(0.8)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

// MARK: - Drill Card

struct DrillCard: View {
    let drill: Drill
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(drill.category.color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: drill.category.icon)
                        .font(.system(size: 20))
                        .foregroundColor(drill.category.color)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(drill.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    HStack(spacing: 8) {
                        // Format display
                        if !drill.formatDisplay.isEmpty {
                            Label(drill.formatDisplay, systemImage: "clock")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        
                        // Level badge
                        Text(drill.level.displayName)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(levelColor(drill.level))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(levelColor(drill.level).opacity(0.2))
                            .cornerRadius(6)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.4))
            }
            .padding(16)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
        }
        .buttonStyle(.plain)
    }
    
    private func levelColor(_ level: DrillLevel) -> Color {
        switch level {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }
}

// MARK: - Placeholder Extension

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    DrillLibraryView()
}
