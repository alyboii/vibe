//
//  AssignedTasksView.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 7.01.2026.
//

import SwiftUI

struct AssignedTasksView: View {
    @StateObject private var assignmentService = AssignmentService.shared
    @State private var selectedAssignment: Assignment?
    @State private var showDrillDetail = false
    
    private var todayTasks: [Assignment] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        return assignmentService.assignments.filter { assignment in
            let dueDay = calendar.startOfDay(for: assignment.dueDate)
            return dueDay <= tomorrow && assignment.status != .completed && assignment.status != .cancelled
        }
    }
    
    private var upcomingTasks: [Assignment] {
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: Date()))!
        
        return assignmentService.assignments.filter { assignment in
            let dueDay = calendar.startOfDay(for: assignment.dueDate)
            return dueDay > tomorrow && assignment.status != .completed && assignment.status != .cancelled
        }
    }
    
    private var completedTasks: [Assignment] {
        assignmentService.assignments.filter { $0.status == .completed }
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
                VStack(alignment: .leading, spacing: 4) {
                    Text("Görevlerim")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Koçunuzun atadığı antrenmanlar")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
                if assignmentService.isLoading {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                    Spacer()
                } else if assignmentService.assignments.isEmpty {
                    Spacer()
                    EmptyStateView(
                        icon: "clipboard",
                        title: "Henüz görev yok",
                        subtitle: "Koçunuz size antrenman atadığında burada görünecek"
                    )
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            // Today's Tasks
                            if !todayTasks.isEmpty {
                                TaskSection(title: "Bugün", icon: "sun.max.fill", color: .yellow) {
                                    ForEach(todayTasks) { assignment in
                                        AssignmentCard(assignment: assignment) {
                                            selectedAssignment = assignment
                                            showDrillDetail = true
                                        }
                                    }
                                }
                            }
                            
                            // Upcoming Tasks
                            if !upcomingTasks.isEmpty {
                                TaskSection(title: "Yaklaşan", icon: "calendar", color: .blue) {
                                    ForEach(upcomingTasks) { assignment in
                                        AssignmentCard(assignment: assignment) {
                                            selectedAssignment = assignment
                                            showDrillDetail = true
                                        }
                                    }
                                }
                            }
                            
                            // Completed Tasks
                            if !completedTasks.isEmpty {
                                TaskSection(title: "Tamamlanan", icon: "checkmark.circle.fill", color: .green, collapsed: true) {
                                    ForEach(completedTasks.prefix(5)) { assignment in
                                        AssignmentCard(assignment: assignment, isCompleted: true) {
                                            selectedAssignment = assignment
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .task {
            do {
                _ = try await assignmentService.getPlayerAssignments()
            } catch {
                print("Failed to load assignments: \(error)")
            }
        }
        .refreshable {
            do {
                _ = try await assignmentService.getPlayerAssignments()
            } catch {
                print("Failed to refresh assignments: \(error)")
            }
        }
        .sheet(isPresented: $showDrillDetail) {
            if let assignment = selectedAssignment {
                AssignmentDetailView(assignment: assignment)
            }
        }
    }
}

// MARK: - Task Section

struct TaskSection<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    var collapsed: Bool = false
    @ViewBuilder let content: Content
    
    @State private var isExpanded = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: {
                withAnimation(.spring(response: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: 10) {
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(color)
                    
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            
            if isExpanded {
                content
            }
        }
        .onAppear {
            if collapsed {
                isExpanded = false
            }
        }
    }
}

// MARK: - Assignment Card

struct AssignmentCard: View {
    let assignment: Assignment
    var isCompleted: Bool = false
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Category Icon
                ZStack {
                    Circle()
                        .fill(assignment.drillCategory.color.opacity(isCompleted ? 0.1 : 0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: assignment.drillCategory.icon)
                        .font(.system(size: 20))
                        .foregroundColor(assignment.drillCategory.color.opacity(isCompleted ? 0.5 : 1))
                }
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(assignment.drillName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(isCompleted ? 0.5 : 1))
                        .lineLimit(1)
                    
                    HStack(spacing: 12) {
                        // Target
                        Label(assignment.target.displayFormat, systemImage: "target")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.6))
                        
                        // Due date
                        if !isCompleted {
                            Label(assignment.dueDateDisplay, systemImage: "clock")
                                .font(.system(size: 12))
                                .foregroundColor(assignment.isOverdue ? .red : .white.opacity(0.6))
                        }
                    }
                }
                
                Spacer()
                
                // Status indicator
                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.green)
                } else if assignment.isOverdue {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.red)
                } else {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.4))
                }
            }
            .padding(16)
            .background(.ultraThinMaterial.opacity(isCompleted ? 0.5 : 1))
            .cornerRadius(16)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Assignment Detail View

struct AssignmentDetailView: View {
    let assignment: Assignment
    @Environment(\.dismiss) private var dismiss
    @StateObject private var drillService = DrillService.shared
    @State private var drill: Drill?
    @State private var showActiveDrill = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.primaryGradientStart, Color.primaryGradientMiddle, Color.primaryGradientEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(assignment.drillCategory.color.opacity(0.2))
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: assignment.drillCategory.icon)
                                    .font(.system(size: 36))
                                    .foregroundColor(assignment.drillCategory.color)
                            }
                            
                            Text(assignment.drillName)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            HStack(spacing: 16) {
                                TagView(text: assignment.drillCategory.displayName, color: assignment.drillCategory.color)
                                TagView(text: assignment.status.displayName, color: statusColor(assignment.status))
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        
                        // Target
                        SectionCard(title: "Hedef", icon: "target") {
                            HStack {
                                Text(assignment.target.displayFormat)
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Text("Son Tarih: \(assignment.dueDateDisplay)")
                                    .font(.system(size: 14))
                                    .foregroundColor(assignment.isOverdue ? .red : .white.opacity(0.7))
                            }
                        }
                        
                        // Notes
                        if let notes = assignment.notes, !notes.isEmpty {
                            SectionCard(title: "Koçtan Not", icon: "message") {
                                Text(notes)
                                    .font(.system(size: 15))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }
                        
                        Spacer().frame(height: 80)
                    }
                    .padding()
                }
                
                // Start Button
                if assignment.status != .completed {
                    VStack {
                        Spacer()
                        
                        Button(action: { showActiveDrill = true }) {
                            HStack(spacing: 12) {
                                Image(systemName: "play.fill")
                                Text("Başlat")
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
                        }
                        .padding()
                    }
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
        .task {
            drill = try? await drillService.getDrill(id: assignment.drillId)
        }
        .fullScreenCover(isPresented: $showActiveDrill) {
            if let drill = drill {
                ActiveDrillView(drill: drill) {
                    showActiveDrill = false
                    dismiss()
                }
            }
        }
    }
    
    private func statusColor(_ status: AssignmentStatus) -> Color {
        switch status {
        case .pending: return .gray
        case .inProgress: return .blue
        case .completed: return .green
        case .overdue: return .red
        case .cancelled: return .gray
        }
    }
}

#Preview {
    AssignedTasksView()
}
