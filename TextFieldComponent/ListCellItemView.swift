//
//  ListCellItemView.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 01/10/24.
//

import Foundation
import SwiftUI

public struct ListCellItemView<TrailingContent: View>: View {
    let listCellItemData: ListCellItemData
    let pressedColor: Color?
    let defaultColor: Color?
    let needsLargerPadding: Bool
    let onSelect: ((ListCellItemData) -> Void)?
    let trailingView: TrailingContent // Placeholder for custom trailing view

    /// Static property remains outside the generic context
    let minCellHeight: CGFloat = 76.0
    
    public init(
        listCellItemData: ListCellItemData,
        pressedColor: Color? = BankingTheme.colors.pressed,
        defaultColor: Color? = BankingTheme.colors.surfaceVariant,
        needsLargerPadding: Bool? = false,
        onSelect: ((ListCellItemData) -> Void)? = nil,
        @ViewBuilder trailingView: () -> TrailingContent // Accepts any view for the trailing placeholder
    ) {
        self.listCellItemData = listCellItemData
        self.pressedColor = pressedColor
        self.defaultColor = defaultColor
        self.needsLargerPadding = needsLargerPadding ?? false
        self.onSelect = onSelect
        self.trailingView = trailingView()
    }

    public var body: some View {
        Button {
            onSelect?(listCellItemData)
        } label: {
            VStack(spacing: BankingTheme.spacing.noPadding) {
                HStack(alignment: .center, spacing: BankingTheme.dimens.small) {
                    // Leading Image Placeholder
                    if let leftIconName = listCellItemData.leftIconName {
                        ListCellIconView(imageName: leftIconName, padding: BankingTheme.dimens.small)
                    }
                    
                    // Primary and Secondary Text
                    listCellTextContent(listCellItemData: listCellItemData)
                    
                    Spacer()
                    
                    // Trailing Placeholder for Custom View
                    trailingView
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(needsLargerPadding ? BankingTheme.dimens.mediumLarge : BankingTheme.dimens.medium)
            }
            .frame(minHeight: minCellHeight) // This works now
            .fixedSize(horizontal: false, vertical: true)
            .buttonStyle(ListCellButtonModifier(pressedColor: pressedColor, defaultColor: defaultColor))
            .ignoresSafeArea()
        }
    }

    /// A subview that renders the primary and optional secondary text for the list cell.
    @ViewBuilder
    private func listCellTextContent(listCellItemData: ListCellItemData) -> some View {
        VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
            Text(listCellItemData.textPrimary)
                .typography(BankingTheme.typography.body)
                .foregroundColor(BankingTheme.colors.textPrimary)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            
            if let textSecondary = listCellItemData.textSecondary {
                Text(textSecondary)
                    .typography(BankingTheme.typography.bodySmall)
                    .foregroundColor(BankingTheme.colors.textSecondary)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct ListCellBadgeIndicatorView: View {
    let actionCount: String?

    var body: some View {
        if let actionCount = actionCount {
            HStack {
                Text(actionCount)
                    .font(BankingTheme.typography.caption.font)
                    .frame(width: BankingTheme.dimens.mediumLarge, height: BankingTheme.dimens.medium)
                    .foregroundColor(BankingTheme.colors.textPrimary)
                    .background(BankingTheme.colors.illustrationBlueShadow)
                    .cornerRadius(BankingTheme.dimens.mediumLarge)
            }
        }
    }
}


struct ListCellWithBadgeAndChevronView: View {
    let listCellItemData: ListCellItemData
    
    var body: some View {
        ListCellItemView(listCellItemData: listCellItemData) {
            HStack {
                // Trailing badge view
                ListCellBadgeIndicatorView(actionCount: listCellItemData.actionCount)
                ListCellIconView(imageName: ComponentConstants.Images.chevron)
            }
        }
    }
}
