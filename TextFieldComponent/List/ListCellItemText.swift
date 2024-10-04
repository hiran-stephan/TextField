//
//  ListCellItemText.swift
//  ListCell
//
//  Created by Hiran Stephan on 04/10/24.
//

import Foundation
import SwiftUI

/// A list cell displaying text, icons, and optional dividers with customizable colors and styles.
struct ListCellItemText: View {
    /// Background color of the cell
    let backgroundColor: Color
    /// Color when the cell is pressed
    let pressedBackgroundColor: Color
    /// Data for labels, icons, and other content
    let listCellItemData: ListCellItemData
    /// Determines whether to show a divider between cells
    let showDivider: Bool
    /// Typography style for the trailing text
    let dataTextStyle: TypographyFont
    /// Action triggered when the cell is clicked
    let onClick: (ListCellItemData) -> Void

    /// Main body rendering the list cell with customizable content
    var body: some View {
        ListCellItemBase(
            backgroundColor: backgroundColor,
            pressedBackgroundColor: pressedBackgroundColor,
            leadingContent: {
                LeadingIconView(listCellItemData: listCellItemData)
            },
            trailingContent: {
                TrailingIconView(
                    listCellItemData: listCellItemData,
                    dataTextStyle: dataTextStyle
                )
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
extension ListCellItemText {

    /// Renders the leading icon, if available.
    @ViewBuilder
    private func LeadingIconView(listCellItemData: ListCellItemData) -> some View {
        if let iconName = listCellItemData.leadingIconName {
            ListCellIconView(imageName: iconName, padding: BankingTheme.dimens.medium)
                .accessibility(label: Text(listCellItemData.leadingIconAccessibilityText ?? ""))
        }
    }

    /// Renders the trailing text or icon, if available.
    @ViewBuilder
    private func TrailingIconView(
        listCellItemData: ListCellItemData,
        dataTextStyle: TypographyFont
    ) -> some View {
        HStack(spacing: BankingTheme.dimens.small) {
            if let data = listCellItemData.data {
                ListCellTextIndicatorView(data: data, dataTextStyle: dataTextStyle)
            }
            
            if let iconName = listCellItemData.trailingIconName, let trailingIconAccessibilityText = listCellItemData.trailingIconAccessibilityText {
                ListCellIconView(imageName: iconName, padding: BankingTheme.dimens.smallMedium)
                    .accessibility(label: Text(trailingIconAccessibilityText))
            }
        }
    }
}
