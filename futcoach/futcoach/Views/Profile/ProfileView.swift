//
//  ProfileView.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 5.01.2026.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
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
                    Text("Profile")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 20)
                    
                    if let user = viewModel.user {
                        // Avatar Section
                        VStack(spacing: 16) {
                            // Initials Avatar
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.accentGradientStart, Color.accentGradientEnd],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 100, height: 100)
                                
                                Text(viewModel.getUserInitials())
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .shadow(color: Color.accentGradientStart.opacity(0.5), radius: 20, x: 0, y: 10)
                            
                            // Name
                            Text(user.fullName)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            // Role Badge
                            HStack(spacing: 6) {
                                Image(systemName: user.role == .player ? "figure.run" : "person.3.fill")
                                    .font(.system(size: 14))
                                Text(user.role?.rawValue.capitalized ?? "No Role")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(.white.opacity(0.2))
                            .cornerRadius(20)
                        }
                        .padding(.vertical, 20)
                        
                        // Info Cards
                        VStack(spacing: 16) {
                            // Email
                            ProfileInfoCard(
                                icon: "envelope.fill",
                                title: "Email",
                                value: user.email
                            )
                            
                            // Member Since
                            ProfileInfoCard(
                                icon: "calendar",
                                title: "Member Since",
                                value: viewModel.formatJoinDate()
                            )
                            
                            // User ID (for debugging/support)
                            ProfileInfoCard(
                                icon: "number",
                                title: "User ID",
                                value: String((user.id ?? "Unknown").prefix(8))
                            )
                        }
                        .padding(.horizontal)
                        
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
                        
                        // Sign Out Button
                        Button(action: {
                            Task {
                                await authViewModel.signOut()
                            }
                        }) {
                            HStack(spacing: 12) {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .font(.system(size: 18, weight: .bold))
                                    Text("Sign Out")
                                        .font(.system(size: 18, weight: .bold))
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(.red.opacity(0.8))
                            .cornerRadius(16)
                            .shadow(color: .red.opacity(0.4), radius: 20, x: 0, y: 10)
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        .disabled(viewModel.isLoading)
                        
                    } else {
                        // Loading State
                        VStack(spacing: 16) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(1.5)
                            
                            Text("Loading profile...")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.vertical, 100)
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

struct ProfileInfoCard: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
                
                Text(value)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding(20)
        .cardStyle()
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
