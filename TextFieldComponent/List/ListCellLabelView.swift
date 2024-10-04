//
//  ListCellLabelView.swift
//  ListCell
//
//  Created by Hiran Stephan on 04/10/24.
//

import Foundation
import SwiftUI

/// A component that handles the display of primary and secondary text labels in a list cell.
public struct ListCellLabelView: View {

    let actionPrimaryLabel: String
    let actionSecondaryLabel: String?

    /// Initializes the `ListCellLabelView` with the provided primary and secondary labels.
    /// - Parameters:
    ///   - actionPrimaryLabel: The required primary text label.
    ///   - actionSecondaryLabel: The optional secondary text label.
    public init(actionPrimaryLabel: String, actionSecondaryLabel: String?) {
        self.actionPrimaryLabel = actionPrimaryLabel
        self.actionSecondaryLabel = actionSecondaryLabel
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
            Text(actionPrimaryLabel)
                .typography(BankingTheme.typography.body)
                .foregroundColor(BankingTheme.colors.textPrimary)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)

            if let actionSecondaryLabel = actionSecondaryLabel {
                Text(actionSecondaryLabel)
                    .typography(BankingTheme.typography.bodySmall)
                    .foregroundColor(BankingTheme.colors.textSecondary)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

