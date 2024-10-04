//
//  ListCellBase.swift
//  ListCell
//
//  Created by Hiran Stephan on 03/10/24.
//

import Foundation
import SwiftUI

import SwiftUI

/// A base container for a list cell that arranges leading, trailing, and label components.
struct ListCellItemBase<LeadingContent: View, TrailingContent: View>: View {
    /// The default background color of the cell.
    let backgroundColor: Color
    /// The background color when the cell is pressed.
    let pressedBackgroundColor: Color
    /// The minimum height for the list cell.
    let minHeight: CGFloat = 76.0
    /// Closure providing the leading content (typically an icon).
    let leadingContent: () -> LeadingContent
    /// Closure providing the trailing content (badge or icon).
    let trailingContent: () -> TrailingContent
    /// The primary label text for the cell.
    let actionPrimaryLabel: String
    /// The optional secondary label text for the cell.
    let actionSecondaryLabel: String?
    /// Determines whether to show a divider at the bottom of the cell.
    let showDivider: Bool
    /// The action to be triggered when the cell is clicked.
    let onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            VStack(spacing: BankingTheme.spacing.noPadding) {
                HStack(alignment: .center, spacing: BankingTheme.dimens.small) {
                    leadingContent()
                    
                    ListCellLabelView(actionPrimaryLabel: actionPrimaryLabel, actionSecondaryLabel: actionSecondaryLabel)
                    
                    Spacer()
                    
                    trailingContent()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(minHeight: minHeight)
        }
        .buttonStyle(ListCellButtonModifier(
            backgroundColor: backgroundColor,
            pressedBackgroundColor: pressedBackgroundColor,
            showDivider: showDivider)
        )
    }
}
