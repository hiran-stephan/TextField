//
//  AlertBanner.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 27/09/24.
//

import Foundation

struct AlertBanner: View {
    let alertMessage: String
    let resultMessage: String
    let retryTitle: String
    let retryAction: () -> Void

    // Default retry title if not provided
    init(alertMessage: String,
         resultMessage: String,
         retryTitle: String = "Retry",
         retryAction: @escaping () -> Void) {
        self.alertMessage = alertMessage
        self.resultMessage = resultMessage
        self.retryTitle = retryTitle
        self.retryAction = retryAction
    }
    
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
    
    // Subcomponents

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
