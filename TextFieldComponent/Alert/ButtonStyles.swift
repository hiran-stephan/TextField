//
//  ButtonStyles.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 25/09/24.
//

import Foundation
import SwiftUI

// MARK: - CustomButtonStyle
/// A single `ButtonStyle` that customizes the appearance of a button based on its type (`default`, `destructive`, `cancel`).
struct CustomButtonStyle: ButtonStyle {
    let type: AlertButtonType
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor(for: type).opacity(configuration.isPressed ? 0.7 : 1.0))
            .foregroundColor(.white)
            .cornerRadius(AlertConstants.cornerRadius)
    }
    
    // Background colors based on the button type
    private func backgroundColor(for type: AlertButtonType) -> Color {
        switch type {
        case .destructive:
            return AlertConstants.destructiveButtonBackground
        case .cancel:
            return AlertConstants.cancelButtonBackground
        default:
            return AlertConstants.defaultButtonBackground
        }
    }
}

