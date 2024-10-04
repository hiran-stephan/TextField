//
//  ListCell.swift
//  ListCell
//
//  Created by Hiran Stephan on 03/10/24.
//

import Foundation
import SwiftUI

/// A list cell component that displays primary and secondary labels with optional leading and trailing icons.
struct ListCellItem: View {
    /// The default background color of the cell.
    let backgroundColor: Color
    /// The background color when the cell is pressed.
    let pressedBackgroundColor: Color
    /// The data model containing the cell's labels, icons, and other content.
    let listCellItemData: ListCellItemData
    /// Determines whether a divider should be shown beneath the cell.
    let showDivider: Bool
    /// The action to be triggered when the cell is clicked, passing the cell's data.
    let onClick: (ListCellItemData) -> Void

    var body: some View {
        ListCellItemBase(
            backgroundColor: backgroundColor,
            pressedBackgroundColor: pressedBackgroundColor,
            leadingContent: {
                LeadingIconView(listCellItemData: listCellItemData)
            },
            trailingContent: {
                TrailingIconView(listCellItemData: listCellItemData)
            },
            actionPrimaryLabel: listCellItemData.actionPrimaryLabel,
            actionSecondaryLabel: listCellItemData.actionSecondaryLabel,
            showDivider: showDivider,
            onClick: {
                onClick(listCellItemData)
            }
        )
    }
}

// MARK: - ViewBuilders
extension ListCellItem {
    
    /// Renders the leading icon in the list cell, if available.
    /// - Parameter listCellItemData: The data model containing the leading icon details.
    @ViewBuilder
    private func LeadingIconView(listCellItemData: ListCellItemData) -> some View {
        if let iconName = listCellItemData.leadingIconName {
            ListCellIconView(imageName: iconName, padding: BankingTheme.dimens.medium)
                .accessibility(label: Text(listCellItemData.leadingIconAccessibilityText ?? ""))
        }
    }

    /// Renders the trailing badge and icon in the list cell, if available.
    /// - Parameter listCellItemData: The data model containing the trailing badge and icon details.
    @ViewBuilder
    private func TrailingIconView(listCellItemData: ListCellItemData) -> some View {
        HStack(spacing: BankingTheme.dimens.small) {
            if let count = listCellItemData.actionCount {
                ListCellBadgeIndicatorView(actionCount: count)
            }
            
            if let iconName = listCellItemData.trailingIconName, let trailingIconAccessibilityText = listCellItemData.trailingIconAccessibilityText {
                ListCellIconView(imageName: iconName, padding: BankingTheme.dimens.smallMedium)
                    .accessibility(label: Text(trailingIconAccessibilityText))
            }
        }
    }
}
