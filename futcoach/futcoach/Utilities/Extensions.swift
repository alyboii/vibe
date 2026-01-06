//
//  Extensions.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 5.01.2026.
//

import Foundation
import SwiftUI

// MARK: - Date Extensions
extension Date {
    func formatted(style: DateFormatter.Style = .medium) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
    
    func timeFormatted() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
}

// MARK: - Color Extensions
extension Color {
    static let primaryGradientStart = Color(red: 0.05, green: 0.2, blue: 0.45)
    static let primaryGradientMiddle = Color(red: 0.1, green: 0.35, blue: 0.6)
    static let primaryGradientEnd = Color(red: 0.15, green: 0.5, blue: 0.35)
    
    static let accentGradientStart = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let accentGradientEnd = Color(red: 0.15, green: 0.5, blue: 0.75)
}

// MARK: - View Extensions
extension View {
    func glassBackground(opacity: Double = 0.15) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(opacity))
        )
    }
    
    func cardStyle() -> some View {
        self
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    )
            )
    }
    
    // Dismiss keyboard on tap
    func dismissKeyboardOnTap() -> some View {
        self
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
    }
}
