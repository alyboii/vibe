//
//  HapticManager.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 6.01.2026.
//

import UIKit

/// Centralized haptic feedback manager for consistent tactile feedback across the app
enum HapticManager {
    
    // MARK: - Impact Feedback
    
    /// Trigger an impact haptic with the specified style
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /// Light impact - for subtle interactions like chart point selection
    static func lightImpact() {
        impact(.light)
    }
    
    /// Medium impact - for more significant interactions like streak extension
    static func mediumImpact() {
        impact(.medium)
    }
    
    /// Heavy impact - for major events
    static func heavyImpact() {
        impact(.heavy)
    }
    
    // MARK: - Notification Feedback
    
    /// Trigger a notification haptic
    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    /// Success notification - for goal completion, sync success
    static func success() {
        notification(.success)
    }
    
    /// Warning notification - for approaching limits or warnings
    static func warning() {
        notification(.warning)
    }
    
    /// Error notification - for failures
    static func error() {
        notification(.error)
    }
    
    // MARK: - Selection Feedback
    
    /// Selection changed - for picker/chip selection
    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
}
