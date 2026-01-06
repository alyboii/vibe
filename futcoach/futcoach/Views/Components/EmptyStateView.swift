//
//  EmptyStateView.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 6.01.2026.
//

import SwiftUI

/// Reusable empty state view with illustration, message, and optional CTA
struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Animated icon
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.3))
                .offset(y: isAnimating ? -5 : 5)
                .animation(
                    .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                    value: isAnimating
                )
                .onAppear {
                    isAnimating = true
                }
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.system(size: 14, weight: .semibold))
                        Text(actionTitle)
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        Capsule()
                            .fill(Color.accentGradientStart)
                    )
                    .shadow(color: Color.accentGradientStart.opacity(0.4), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
    }
}

/// Empty state specifically for charts
struct ChartEmptyStateView: View {
    var onSyncTapped: (() -> Void)? = nil
    
    var body: some View {
        EmptyStateView(
            icon: "chart.line.uptrend.xyaxis",
            title: "Ready to get moving?",
            subtitle: "Sync with HealthKit or log your first activity to start tracking your progress",
            actionTitle: "Sync Now",
            action: onSyncTapped
        )
        .cardStyle()
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [Color.primaryGradientStart, Color.primaryGradientMiddle, Color.primaryGradientEnd],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        VStack(spacing: 24) {
            ChartEmptyStateView {
                print("Sync tapped")
            }
            .padding(.horizontal)
            
            EmptyStateView(
                icon: "target",
                title: "No goals set yet",
                subtitle: "Set your first daily goal to start building streaks"
            )
            .cardStyle()
            .padding(.horizontal)
        }
    }
}
