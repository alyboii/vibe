//
//  JoinTeamView.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 7.01.2026.
//

import SwiftUI

struct JoinTeamView: View {
    @StateObject private var teamService = TeamService.shared
    @State private var teamCode = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showSuccess = false
    @State private var joinedTeam: Team?
    
    @FocusState private var isCodeFocused: Bool
    
    var onTeamJoined: ((Team) -> Void)?
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.primaryGradientStart, Color.primaryGradientMiddle, Color.primaryGradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "person.3.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, .white.opacity(0.7)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        Text("Takıma Katıl")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Koçunuzdan aldığınız 4 haneli kodu girin")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 60)
                    
                    // Code Input
                    VStack(spacing: 16) {
                        HStack(spacing: 12) {
                            ForEach(0..<4, id: \.self) { index in
                                CodeDigitBox(
                                    digit: getDigit(at: index),
                                    isFocused: isCodeFocused && teamCode.count == index
                                )
                            }
                        }
                        
                        // Hidden text field for input
                        TextField("", text: $teamCode)
                            .keyboardType(.numberPad)
                            .focused($isCodeFocused)
                            .opacity(0)
                            .frame(height: 0)
                            .onChange(of: teamCode) { newValue in
                                // Limit to 4 digits
                                if newValue.count > 4 {
                                    teamCode = String(newValue.prefix(4))
                                }
                                // Only allow numbers
                                teamCode = newValue.filter { $0.isNumber }
                                
                                // Auto-submit when 4 digits entered
                                if teamCode.count == 4 {
                                    Task {
                                        await joinTeam()
                                    }
                                }
                            }
                        
                        Text("Koda dokunarak düzenleyebilirsiniz")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .onTapGesture {
                        isCodeFocused = true
                    }
                    
                    // Error Message
                    if let error = errorMessage {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                            
                            Text(error)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.red)
                        }
                        .padding()
                        .background(Color.red.opacity(0.15))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    // Join Button
                    Button(action: {
                        Task {
                            await joinTeam()
                        }
                    }) {
                        HStack(spacing: 12) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.system(size: 20))
                                Text("Takıma Katıl")
                                    .font(.system(size: 18, weight: .bold))
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: teamCode.count == 4 ?
                                    [Color.accentGradientStart, Color.accentGradientEnd] :
                                    [Color.gray.opacity(0.5), Color.gray.opacity(0.3)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: teamCode.count == 4 ? Color.accentGradientStart.opacity(0.5) : .clear, radius: 20, x: 0, y: 10)
                    }
                    .disabled(teamCode.count != 4 || isLoading)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Help Text
                    VStack(spacing: 8) {
                        Text("Kod almadınız mı?")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text("Koçunuzdan takım kodunu isteyin")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            // Auto-focus code input
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isCodeFocused = true
            }
        }
        .sheet(isPresented: $showSuccess) {
            if let team = joinedTeam {
                TeamJoinedSuccessView(team: team) {
                    showSuccess = false
                    onTeamJoined?(team)
                }
            }
        }
    }
    
    private func getDigit(at index: Int) -> String? {
        guard index < teamCode.count else { return nil }
        let stringIndex = teamCode.index(teamCode.startIndex, offsetBy: index)
        return String(teamCode[stringIndex])
    }
    
    private func joinTeam() async {
        guard teamCode.count == 4 else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let team = try await teamService.joinTeam(code: teamCode)
            joinedTeam = team
            showSuccess = true
            HapticManager.success()
        } catch {
            errorMessage = error.localizedDescription
            HapticManager.error()
            // Clear code on error
            teamCode = ""
        }
        
        isLoading = false
    }
}

// MARK: - Code Digit Box

struct CodeDigitBox: View {
    let digit: String?
    let isFocused: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isFocused ? Color.white : Color.white.opacity(0.2), lineWidth: 2)
                )
                .frame(width: 65, height: 80)
            
            if let digit = digit {
                Text(digit)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            } else if isFocused {
                Rectangle()
                    .fill(.white)
                    .frame(width: 2, height: 30)
                    .opacity(isFocused ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isFocused)
            }
        }
        .scaleEffect(digit != nil ? 1.05 : 1.0)
        .animation(.spring(response: 0.3), value: digit)
    }
}

// MARK: - Success View

struct TeamJoinedSuccessView: View {
    let team: Team
    let onContinue: () -> Void
    
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
                
                // Success Icon
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.2))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.green)
                }
                
                VStack(spacing: 12) {
                    Text("Takıma Katıldınız!")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(team.name)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))
                }
                
                Text("Artık koçunuzun atadığı antrenmanları görebilir ve ilerlemenizi takip edebilirsiniz.")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
                
                Button(action: onContinue) {
                    Text("Devam Et")
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
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    JoinTeamView()
}
