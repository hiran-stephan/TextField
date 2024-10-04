//
//  ListCellButtonModifier.swift
//  ListCell
//
//  Created by Hiran Stephan on 04/10/24.
//

import Foundation
import SwiftUI

/// A custom button style for list cells that adds a divider at the bottom and changes the background color when pressed.
struct ListCellButtonModifier: ButtonStyle {
    /// The default background color of the button.
    var backgroundColor: Color = BankingTheme.colors.surfaceVariant
    /// The background color when the button is pressed.
    var pressedBackgroundColor: Color = BankingTheme.colors.pressed
    /// A flag indicating whether to show a divider at the bottom of the button.
    var showDivider: Bool = true
    
    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 0) {
            configuration.label
                .frame(maxWidth: .infinity)
                .background(configuration.isPressed ? pressedBackgroundColor : backgroundColor)
            
            if showDivider {
                Divider()
                    .frame(height: BankingTheme.spacing.stroke)
                    .background(BankingTheme.colors.borderDefault)
            }
        }
    }
}

