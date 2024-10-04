//
//  ListCellTextIndicatorView.swift
//  ListCell
//
//  Created by Hiran Stephan on 04/10/24.
//

import Foundation
import SwiftUI

import SwiftUI

/// A view that displays text data in a list cell, styled with a customizable typography font.
struct ListCellTextIndicatorView: View {
    
    let data: String
    let dataTextStyle: TypographyFont
    
    /// Initializes the `ListCellTextIndicatorView` with text data and an optional text style.
    /// - Parameters:
    ///   - data: The text data to display.
    ///   - dataTextStyle: The text style to apply (defaults to `bodySmall`).
    init(data: String, dataTextStyle: TypographyFont = BankingTheme.typography.bodySmall) {
        self.data = data
        self.dataTextStyle = dataTextStyle
    }
    
    var body: some View {
        HStack {
            Text(data)
                .typography(dataTextStyle)
                .foregroundColor(BankingTheme.colors.textSecondary)
        }
    }
}

