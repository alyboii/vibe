//
//  TeamManagementView.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 7.01.2026.
//

import SwiftUI

struct TeamManagementView: View {
    @StateObject private var teamService = TeamService.shared
    @State private var showCreateTeam = false
    @State private var isLoading = false
    @State private var teams: [Team] = []
    
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
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Takım Yönetimi")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Takımlarınızı yönetin ve kod paylaşın")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Button(action: { showCreateTeam = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                if isLoading {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                    Spacer()
                } else if teams.isEmpty {
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "person.3.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.3))
                        
                        Text("Henüz takım yok")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("İlk takımınızı oluşturarak başlayın")
                            .font(.system(size: 15))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Button(action: { showCreateTeam = true }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Takım Oluştur")
                            }
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                LinearGradient(
                                    colors: [Color.accentGradientStart, Color.accentGradientEnd],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                        }
                    }
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(teams) { team in
                                TeamCard(team: team, onRotateCode: {
                                    await rotateCode(for: team)
                                })
                            }
                        }
                        .padding()
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .task {
            await loadTeams()
        }
        .sheet(isPresented: $showCreateTeam) {
            CreateTeamView { newTeam in
                teams.append(newTeam)
                showCreateTeam = false
            }
        }
    }
    
    private func loadTeams() async {
        isLoading = true
        do {
            teams = try await teamService.getCoachTeams()
        } catch {
            print("Failed to load teams: \(error)")
        }
        isLoading = false
    }
    
    private func rotateCode(for team: Team) async {
        guard let teamId = team.id else { return }
        
        do {
            let newCode = try await teamService.rotateTeamCode(teamId: teamId)
            if let index = teams.firstIndex(where: { $0.id == teamId }) {
                teams[index].teamCode = newCode
            }
            HapticManager.success()
        } catch {
            print("Failed to rotate code: \(error)")
        }
    }
}

// MARK: - Team Card

struct TeamCard: View {
    let team: Team
    let onRotateCode: () async -> Void
    
    @State private var showCodeCopied = false
    @State private var isRotating = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(team.name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 12))
                        Text("\(team.memberCount) oyuncu")
                            .font(.system(size: 14))
                    }
                    .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                // Status badge
                Text(team.isActive ? "Aktif" : "Pasif")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(team.isActive ? .green : .gray)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(team.isActive ? Color.green.opacity(0.2) : Color.gray.opacity(0.2))
                    .cornerRadius(20)
            }
            
            Divider()
                .background(.white.opacity(0.2))
            
            // Team Code
            VStack(spacing: 12) {
                Text("Takım Kodu")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.6))
                
                HStack(spacing: 8) {
                    ForEach(Array(team.teamCode), id: \.self) { digit in
                        Text(String(digit))
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(width: 50, height: 60)
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                    }
                }
                
                // Code actions
                HStack(spacing: 20) {
                    Button(action: copyCode) {
                        HStack(spacing: 6) {
                            Image(systemName: showCodeCopied ? "checkmark" : "doc.on.doc")
                            Text(showCodeCopied ? "Kopyalandı" : "Kopyala")
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Button(action: {
                        Task {
                            isRotating = true
                            await onRotateCode()
                            isRotating = false
                        }
                    }) {
                        HStack(spacing: 6) {
                            if isRotating {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "arrow.clockwise")
                            }
                            Text("Yenile")
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.orange)
                    }
                    .disabled(isRotating)
                }
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
    
    private func copyCode() {
        UIPasteboard.general.string = team.teamCode
        showCodeCopied = true
        HapticManager.lightImpact()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showCodeCopied = false
        }
    }
}

// MARK: - Create Team View

struct CreateTeamView: View {
    let onCreate: (Team) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var teamService = TeamService.shared
    @State private var teamName = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.primaryGradientStart, Color.primaryGradientMiddle, Color.primaryGradientEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 32) {
                    // Icon
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "person.3.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 40)
                    
                    // Form
                    VStack(spacing: 16) {
                        Text("Takım Adı")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        TextField("", text: $teamName)
                            .placeholder(when: teamName.isEmpty) {
                                Text("Örn: U17 A Takımı")
                                    .foregroundColor(.white.opacity(0.4))
                            }
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    if let error = errorMessage {
                        Text(error)
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    // Create Button
                    Button(action: createTeam) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Takım Oluştur")
                                    .font(.system(size: 18, weight: .bold))
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: teamName.isEmpty ?
                                    [Color.gray.opacity(0.5), Color.gray.opacity(0.3)] :
                                    [Color.accentGradientStart, Color.accentGradientEnd],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                    }
                    .disabled(teamName.isEmpty || isLoading)
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Yeni Takım")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") { dismiss() }
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    private func createTeam() {
        guard !teamName.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let team = try await teamService.createTeam(name: teamName)
                onCreate(team)
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}

#Preview {
    TeamManagementView()
}
