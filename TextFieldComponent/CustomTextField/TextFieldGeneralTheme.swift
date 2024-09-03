//
//  TextInputTheme.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 30/08/24.
//

import Foundation
import SwiftUI


// Constants for Colors, Spacing, and Fonts
struct TextFieldGeneralTheme {
    struct Colors {
        static let borderColor = BankingTheme.colors.textSecondary
        static let errorColor = BankingTheme.colors.primary
        static let errorBgColor = BankingTheme.colors.errorContainer
        static let backgroundColor = BankingTheme.colors.background
        static let primaryTextColor = BankingTheme.colors.textPrimary
        static let disabledTextColor = BankingTheme.colors.disabled
    }
    
    struct Spacing {
        static let textFieldHeight: CGFloat = BankingTheme.spacing.appBarHeight // 56
        static let textFieldPadding: CGFloat = BankingTheme.spacing.paddingSmall // 8
        static let labelHeight: CGFloat = BankingTheme.spacing.buttonMinHeight // 44
        static let iconSize: CGFloat = BankingTheme.spacing.paddingLarge // 24
        static let iconPadding: CGFloat = BankingTheme.spacing.paddingSmall // 8
        static let leadingTextFieldPadding: CGFloat = BankingTheme.spacing.paddingMicroMedium // 10
        static let errorTextTopPadding: CGFloat = BankingTheme.spacing.paddingSmall // 4
        static let errorContainerHeight: CGFloat = 28
        static let containerPadding: CGFloat = BankingTheme.spacing.paddingMedium // 16
        static let cornerRadius: CGFloat = BankingTheme.spacing.paddingSmallMedium // 12
        static let labelIconHeight: CGFloat = BankingTheme.spacing.paddingLarge // 24
        static let leadingIconHeight: CGFloat = BankingTheme.spacing.paddingLarge // 24
        static let trailingIconHeight: CGFloat = BankingTheme.spacing.paddingLarge // 24
    }
    
    struct Fonts {
        static let labelFont = BankingTheme.typography.body.font
        static let errorFont = BankingTheme.typography.bodySmall.font
    }
    
    struct Images {
        static let labelIcon = "quick-tip"
        static let trailingIcon = "profile"
    }
}















