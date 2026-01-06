//
//  CustomTextField.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 5.01.2026.
//

import SwiftUI

struct CustomTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(isFocused ? .white : .white.opacity(0.7))
                .font(.system(size: 20))
                .frame(width: 24)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .focused($isFocused)
                    .foregroundColor(.white)
                    .accentColor(.white)
                    .font(.system(size: 16, weight: .medium))
            } else {
                TextField(placeholder, text: $text)
                    .focused($isFocused)
                    .foregroundColor(.white)
                    .accentColor(.white)
                    .font(.system(size: 16, weight: .medium))
                    .autocapitalization(.none)
                    .keyboardType(icon == "envelope.fill" ? .emailAddress : .default)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(isFocused ? 0.25 : 0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isFocused ? .white.opacity(0.5) : .clear, lineWidth: 2)
                )
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [Color(red: 0.1, green: 0.3, blue: 0.6), Color(red: 0.2, green: 0.5, blue: 0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        VStack(spacing: 20) {
            CustomTextField(icon: "envelope.fill", placeholder: "Email", text: .constant(""))
            CustomTextField(icon: "lock.fill", placeholder: "Password", text: .constant(""), isSecure: true)
        }
        .padding()
    }
}
