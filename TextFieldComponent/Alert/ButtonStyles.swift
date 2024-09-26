//
//  ButtonStyles.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 25/09/24.
//

import Foundation
import SwiftUI

// MARK: - Button Styles
/// Default button style for regular buttons.
struct DefaultButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(AlertConstants.defaultButtonBackground.opacity(configuration.isPressed ? 0.7 : 1.0))
            .foregroundColor(AlertConstants.buttonForegroundColor)
            .cornerRadius(AlertConstants.cornerRadius)
    }
}

/// Destructive button style for buttons that perform destructive actions.
struct DestructiveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(AlertConstants.destructiveButtonBackground.opacity(configuration.isPressed ? 0.7 : 1.0))
            .foregroundColor(AlertConstants.buttonForegroundColor)
            .cornerRadius(AlertConstants.cornerRadius)
    }
}

/// Cancel button style for buttons that dismiss the alert.
struct CancelButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(AlertConstants.cancelButtonBackground.opacity(configuration.isPressed ? 0.7 : 1.0))
            .foregroundColor(AlertConstants.buttonForegroundColor)
            .cornerRadius(AlertConstants.cornerRadius)
    }
}
