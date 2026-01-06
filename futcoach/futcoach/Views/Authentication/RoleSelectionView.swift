//
//  RoleSelectionView.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 5.01.2026.
//

import SwiftUI

struct RoleSelectionView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = RoleSelectionViewModel()
    
    var body: some View {
        ZStack {
            // Premium gradient background
            LinearGradient(
                colors: [
                    Color.primaryGradientStart,
                    Color.primaryGradientMiddle,
                    Color.primaryGradientEnd
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .white.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    
                    Text("Choose Your Role")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Select how you'll use FutCoach")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                // Role Cards
                VStack(spacing: 20) {
                    // Player Card
                    RoleCard(
                        icon: "figure.run",
                        title: "Player",
                        description: "Track your performance and get AI training plans",
                        isSelected: viewModel.selectedRole == .player
                    ) {
                        selectRole(.player)
                    }
                    
                    // Coach Card
                    RoleCard(
                        icon: "person.3.fill",
                        title: "Coach",
                        description: "Monitor your team and manage player progress",
                        isSelected: viewModel.selectedRole == .coach
                    ) {
                        selectRole(.coach)
                    }
                }
                .padding(.horizontal, 30)
                
                // Error Message
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.system(size: 14))
                        .foregroundColor(.red.opacity(0.9))
                        .padding(.horizontal, 30)
                        .transition(.opacity)
                }
                
                Spacer()
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func selectRole(_ role: UserRole) {
        guard let userId = authViewModel.currentUser?.id else { return }
        
        Task {
            await viewModel.selectRole(role, for: userId)
            // Update auth view model
            await authViewModel.updateRole(role)
        }
    }
}

struct RoleCard: View {
    let icon: String
    let title: String
    let description: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                Image(systemName: icon)
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                    .frame(width: 60)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(description)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.green)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white.opacity(isSelected ? 0.25 : 0.15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(isSelected ? .white.opacity(0.6) : .white.opacity(0.3), lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

#Preview {
    NavigationStack {
        RoleSelectionView()
            .environmentObject(AuthViewModel())
    }
}
