//
//  AlertBanner.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 27/09/24.
//

import Foundation
import SwiftUI

/// A reusable view component that displays an alert message with an optional retry button and a result message.
/// It is designed to be flexible and customizable for various alerting use cases.
struct AlertBanner: View {
    // MARK: - Properties
    
    /// The main alert message to be displayed in the banner.
    let alertMessage: String
    
    /// The result message to be shown below the alert content, typically a code or secondary status.
    let resultMessage: String
    
    /// The title of the retry button. Defaults to "Retry" if not provided.
    let retryTitle: String
    
    /// The action to be executed when the retry button is tapped.
    let retryAction: () -> Void
    
    // MARK: - Initializer
    
    /// Initializes the `AlertBanner` component with the given parameters.
    ///
    /// - Parameters:
    ///   - alertMessage: The main alert message to display.
    ///   - resultMessage: A secondary message or code.
    ///   - retryTitle: The label for the retry button. Defaults to "Retry".
    ///   - retryAction: The action triggered when the retry button is pressed.
    init(alertMessage: String,
         resultMessage: String,
         retryTitle: String = "Retry",
         retryAction: @escaping () -> Void) {
        self.alertMessage = alertMessage
        self.resultMessage = resultMessage
        self.retryTitle = retryTitle
        self.retryAction = retryAction
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .center, spacing: BankingTheme.dimens.small) {
            alertContentStack
            captionText
        }
        .padding(BankingTheme.dimens.mediumLarge)
        .frame(maxWidth: .infinity, alignment: .top)
        .background(BankingTheme.colors.errorContainer)
        .cornerRadius(BankingTheme.dimens.smallMedium)
        .overlay(
            RoundedRectangle(cornerRadius: BankingTheme.dimens.smallMedium)
                .inset(by: 0.5)
                .stroke(BankingTheme.colors.errorBorder, lineWidth: BankingTheme.spacing.stroke)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(alertMessage). \(retryTitle)")
    }
    
    // MARK: - Subcomponents
    
    /// A horizontal stack containing the alert icon and the alert message with the retry button.
    private var alertContentStack: some View {
        HStack(alignment: .top, spacing: BankingTheme.dimens.smallMedium) {
            Image("alert-general-filled")
                .frame(width: BankingTheme.dimens.mediumLarge, height: BankingTheme.dimens.mediumLarge)
                .accessibilityHidden(true) // Image is decorative, so hidden for accessibility

            VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
                // Error message
                Text(alertMessage)
                    .font(BankingTheme.typography.bodySmall.font)
                    .foregroundColor(BankingTheme.colors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .accessibilityLabel("Error message: \(alertMessage)")

                // Retry Button
                Button(action: retryAction) {
                    Text(retryTitle)
                        .font(BankingTheme.typography.bodySmall.font)
                        .underline()
                        .foregroundColor(BankingTheme.colors.textPrimary)
                        .padding(.top, BankingTheme.dimens.small)
                }
                .buttonStyle(PlainButtonStyle())
                .accessibilityLabel("Retry action: \(retryTitle)")
                .accessibilityAddTraits(.isButton)
            }
        }
    }
    
    /// A horizontal stack containing the result message, typically displayed at the bottom of the alert banner.
    private var captionText: some View {
        HStack(alignment: .center, spacing: BankingTheme.spacing.noPadding) {
            Text(resultMessage)
                .font(BankingTheme.typography.caption.font)
                .multilineTextAlignment(.trailing)
                .foregroundColor(BankingTheme.colors.textSecondary)
                .frame(maxWidth: .infinity, alignment: .topTrailing)
                .accessibilityLabel("Result message: \(resultMessage)")
        }
        .padding(.leading, BankingTheme.dimens.small)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// Example Usage:
/*
 AlertBanner(
     alertMessage: "We've encountered an unexpected error. Please try again later.",
     resultMessage: "Result #0008",
     retryAction: {
         print("Retry tapped")
     }
 )
 */
