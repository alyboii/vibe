//
//  SignUpView.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 5.01.2026.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel:AuthViewModel
    
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var agreedToTerms: Bool = false
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        ZStack {
            // Premium gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.2, blue: 0.45),
                    Color(red: 0.1, green: 0.35, blue: 0.6),
                    Color(red: 0.15, green: 0.5, blue: 0.35)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .dismissKeyboardOnTap()
            
            // Animated floating circles for depth
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
                        .frame(height: 40)
                    
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
                        
                        Text("Create your coaching account")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.bottom, 20)
                    
                    // Form Section
                    VStack(spacing: 20) {
                        CustomTextField(
                            icon: "person.fill",
                            placeholder: "Full Name",
                            text: $fullName
                        )
                        
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
                        
                        CustomTextField(
                            icon: "lock.fill",
                            placeholder: "Confirm Password",
                            text: $confirmPassword,
                            isSecure: true
                        )
                    }
                    .padding(.horizontal, 30)
                    
                    // Terms and Conditions
                    HStack(spacing: 12) {
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                agreedToTerms.toggle()
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(.white.opacity(0.5), lineWidth: 2)
                                    .frame(width: 24, height: 24)
                                
                                if agreedToTerms {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                        .transition(.scale.combined(with: .opacity))
                                }
                            }
                        }
                        
                        Text("I agree to the ")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.system(size: 14))
                        + Text("Terms & Conditions")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .semibold))
                            .underline()
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 10)
                    
                    // Error Message
                    if let errorMessage = authViewModel.errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 14))
                            .foregroundColor(.red.opacity(0.9))
                            .padding(.horizontal, 30)
                            .transition(.opacity)
                    }
                    
                    // Sign Up Button
                    Button(action: handleSignUp) {
                        HStack(spacing: 12) {
                            if authViewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Sign Up")
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
                                colors: [
                                    Color(red: 0.2, green: 0.6, blue: 0.9),
                                    Color(red: 0.15, green: 0.5, blue: 0.75)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: Color(red: 0.2, green: 0.6, blue: 0.9).opacity(0.5), radius: 20, x: 0, y: 10)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 10)
                    .disabled(authViewModel.isLoading)
                    .scaleEffect(authViewModel.isLoading ? 0.95 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: authViewModel.isLoading)
                    
                    // Sign In Link
                    NavigationLink(destination: SignInView()) {
                        HStack(spacing: 6) {
                            Text("Already have an account?")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.system(size: 15))
                            
                            Text("Sign In")
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
        .alert("Validation Error", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .onDisappear {
            authViewModel.clearError()
        }
    }
    
    private func handleSignUp() {
        // Client-side validation
        guard !fullName.isEmpty else {
            showAlert(message: "Please enter your full name")
            return
        }
        
        guard !email.isEmpty else {
            showAlert(message: "Please enter your email")
            return
        }
        
        guard email.contains("@") && email.contains(".") else {
            showAlert(message: "Please enter a valid email address")
            return
        }
        
        guard !password.isEmpty else {
            showAlert(message: "Please enter a password")
            return
        }
        
        guard password.count >= 6 else {
            showAlert(message: "Password must be at least 6 characters")
            return
        }
        
        guard password == confirmPassword else {
            showAlert(message: "Passwords do not match")
            return
        }
        
        guard agreedToTerms else {
            showAlert(message: "Please agree to the Terms & Conditions")
            return
        }
        
        // Call ViewModel
        Task {
            await authViewModel.signUp(email: email, password: password, fullName: fullName)
        }
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        showingAlert = true
    }
}

#Preview {
    NavigationStack {
        SignUpView()
            .environmentObject(AuthViewModel())
    }
}
