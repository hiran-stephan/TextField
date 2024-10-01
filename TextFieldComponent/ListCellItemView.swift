//
//  ListCellItemView.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 01/10/24.
//

import Foundation
import SwiftUI
import SwiftUI

public struct ListCellItemView<BadgeView: View, TrailingView: View>: View {
    let listCellItemData: ListCellItemData
    
    // Optional badge and trailing views
    let badgeView: BadgeView?
    let trailingView: TrailingView?
    
    var minCellHeight: CGFloat
    var pressedColor: Color?
    var defaultColor: Color?
    var needsLargerPadding: Bool = false

    // A closure that is called when the button is tapped.
    let onSelect: ((ListCellItemData) -> Void)?

    // Initializes the `ListCellItemView` with its corresponding data.
    public init(
        listCellItemData: ListCellItemData,
        minCellHeight: CGFloat = 76.0, // Default value
        pressedColor: Color? = BankingTheme.colors.pressed,
        defaultColor: Color? = BankingTheme.colors.surfaceVariant,
        needsLargerPadding: Bool = false,
        badgeView: BadgeView? = nil, // Optional badge view
        trailingView: TrailingView? = nil, // Optional trailing view
        onSelect: ((ListCellItemData) -> Void)? = nil // Moved onSelect to the last parameter
    ) {
        self.listCellItemData = listCellItemData
        self.minCellHeight = minCellHeight
        self.pressedColor = pressedColor
        self.defaultColor = defaultColor
        self.needsLargerPadding = needsLargerPadding
        self.badgeView = badgeView // Assign the badge view if provided
        self.trailingView = trailingView // Assign the trailing view if provided
        self.onSelect = onSelect
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

                    // Optional Badge View
                    if let badgeView = badgeView {
                        badgeView
                    } else {
                        EmptyView() // Handle empty badge view
                    }

                    // Optional Trailing View
                    if let trailingView = trailingView {
                        trailingView
                            .padding(needsLargerPadding ? BankingTheme.dimens.mediumLarge : BankingTheme.dimens.medium)
                    } else {
                        EmptyView() // Handle empty trailing view
                    }
                }
                .frame(minHeight: minCellHeight)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .buttonStyle(ListCellButtonModifier(pressedColor: pressedColor, defaultColor: defaultColor))
        .ignoresSafeArea()
    }

    // Text content rendering (Primary and Secondary)
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




public struct ListCellBadgeIndicatorView: View {
    let actionCount: String?
    
    // Initializer to accept the action count for the badge
    public init(actionCount: String?) {
        self.actionCount = actionCount
    }

    public var body: some View {
        if let count = actionCount {
            HStack {
                Text(count)
                    .font(BankingTheme.typography.caption.font)
                    .frame(width: BankingTheme.dimens.mediumLarge, height: BankingTheme.dimens.medium)
                    .foregroundColor(BankingTheme.colors.textPrimary)
                    .background(BankingTheme.colors.illustrationBlueShadow)
                    .cornerRadius(BankingTheme.dimens.mediumLarge)
            }
        }
    }
}




import SwiftUI

public struct ListCellContainerView<BadgeView: View, TrailingView: View>: View {
    // An array of data objects representing each list cell.
    let listCellItemData: [ListCellItemData]
    
    // Optional closures to provide badgeView and trailingView
    let badgeViewProvider: ((ListCellItemData) -> BadgeView?)? // Optional badgeView provider
    let trailingViewProvider: ((ListCellItemData) -> TrailingView?)? // Optional trailingView provider
    
    // A closure that is called when a cell is selected.
    let onSelect: (ListCellItemData) -> Void

    /// Initializes the `ListCellContainerView` with a list of `ListCellItemData`, optional views for the badge and trailing sections,
    /// and a selection callback.
    public init(
        listCellItemData: [ListCellItemData],
        badgeViewProvider: ((ListCellItemData) -> BadgeView?)? = nil, // Optional
        trailingViewProvider: ((ListCellItemData) -> TrailingView?)? = nil, // Optional
        onSelect: @escaping (ListCellItemData) -> Void // Moved onSelect to the last parameter
    ) {
        self.listCellItemData = listCellItemData
        self.badgeViewProvider = badgeViewProvider
        self.trailingViewProvider = trailingViewProvider
        self.onSelect = onSelect
    }
    
    /// The body of the view that renders each list cell using a `ForEach` loop.
    public var body: some View {
        ForEach(listCellItemData) { itemData in
            ListCellItemView(
                listCellItemData: itemData,
                badgeView: badgeViewProvider?(itemData), // Use the provided badgeView
                trailingView: trailingViewProvider?(itemData), // Use the provided trailingView
                onSelect: { selectedItem in
                    onSelect(selectedItem)
                }
            )
        }
    }
}

