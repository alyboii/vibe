//
//  SignInView.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 5.01.2026.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    
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
            .dismissKeyboardOnTap()
            
            // Floating circles for depth
            Circle()
                .fill(.white.opacity(0.05))
                .frame(width: 300, height: 300)
                .offset(x: -150, y: -300)
                .blur(radius: 50)
            
            Circle()
                .fill(.white.opacity(0.05))
                .frame(width: 250, height: 250)
                .offset(x: 150, y: 400)
                .blur(radius: 50)
            
            ScrollView {
                VStack(spacing: 30) {
                    Spacer()
                        .frame(height: 60)
                    
                    // Header Section
                    VStack(spacing: 12) {
                        Image(systemName: "sportscourt.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, .white.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                        
                        Text("FutCoach")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Welcome back!")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.bottom, 20)
                    
                    // Form Section
                    VStack(spacing: 20) {
                        CustomTextField(
                            icon: "envelope.fill",
                            placeholder: "Email",
                            text: $email
                        )
                        
                        CustomTextField(
                            icon: "lock.fill",
                            placeholder: "Password",
                            text: $password,
                            isSecure: true
                        )
                    }
                    .padding(.horizontal, 30)
                    
                    // Error Message
                    if let errorMessage = authViewModel.errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 14))
                            .foregroundColor(.red.opacity(0.9))
                            .padding(.horizontal, 30)
                            .transition(.opacity)
                    }
                    
                    // Sign In Button
                    Button(action: {
                        Task {
                            await authViewModel.signIn(email: email, password: password)
                        }
                    }) {
                        HStack(spacing: 12) {
                            if authViewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Sign In")
                                    .font(.system(size: 18, weight: .bold))
                                
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .bold))
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
                        .shadow(color: Color.accentGradientStart.opacity(0.5), radius: 20, x: 0, y: 10)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 10)
                    .disabled(authViewModel.isLoading)
                    
                    // Sign Up Link
                    NavigationLink(destination: SignUpView()) {
                        HStack(spacing: 6) {
                            Text("Don't have an account?")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.system(size: 15))
                            
                            Text("Sign Up")
                                .foregroundColor(.white)
                                .font(.system(size: 15, weight: .semibold))
                                .underline()
                        }
                    }
                    .padding(.top, 5)
                    
                    Spacer()
                        .frame(height: 40)
                }
            }
        }
        .onDisappear {
            authViewModel.clearError()
        }
    }
}

#Preview {
    NavigationStack {
        SignInView()
            .environmentObject(AuthViewModel())
    }
}
