//
//  ListCellItemView.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 01/10/24.
//

import Foundation
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
        onSelect: ((ListCellItemData) -> Void)? = nil,
        @ViewBuilder badgeView: (() -> BadgeView)? = nil, // Optional badge view
        @ViewBuilder trailingView: (() -> TrailingView)? = nil // Optional trailing view
    ) {
        self.listCellItemData = listCellItemData
        self.minCellHeight = minCellHeight
        self.pressedColor = pressedColor
        self.defaultColor = defaultColor
        self.needsLargerPadding = needsLargerPadding
        self.onSelect = onSelect
        self.badgeView = badgeView?() // Assign the badge view if provided
        self.trailingView = trailingView?() // Assign the trailing view if provided
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
                    }

                    // Optional Trailing View
                    if let trailingView = trailingView {
                        trailingView
                            .padding(needsLargerPadding ? BankingTheme.dimens.mediumLarge : BankingTheme.dimens.medium)
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

ListCellItemView(
    listCellItemData: someData,
    badgeView: {
        // Use the custom ListCellBadgeIndicatorView here
        ListCellBadgeIndicatorView(actionCount: someData.actionCount)
    },
    trailingView: {
        // Custom trailing view (e.g., Chevron or any other view)
        ListCellIconView(imageName: ComponentConstants.Images.chevron)
    }
)

ListCellItemView(
    listCellItemData: someData,
    badgeView: {
        // A custom badge view, such as a Text view
        Text("Custom Badge")
    },
    trailingView: {
        // A custom trailing view, such as a Text or other indicator
        Text("Trailing")
    }
)

import SwiftUI

public struct ListCellContainerView<BadgeView: View, TrailingView: View>: View {
    // An array of data objects representing each list cell.
    let listCellItemData: [ListCellItemData]
    
    // A closure that is called when a cell is selected.
    let onSelect: (ListCellItemData) -> Void
    
    // Optional closures to provide badgeView and trailingView
    let badgeViewProvider: ((ListCellItemData) -> BadgeView?)? // Optional badgeView provider
    let trailingViewProvider: ((ListCellItemData) -> TrailingView?)? // Optional trailingView provider
    
    /// Initializes the `ListCellContainerView` with a list of `ListCellItemData`, a selection callback,
    /// and optional views for the badge and trailing sections.
    /// - Parameter listCellItemData: The array of data for each list cell.
    /// - Parameter onSelect: A closure to be called when a cell is selected.
    /// - Parameter badgeViewProvider: A closure to provide a custom badgeView for each item (optional).
    /// - Parameter trailingViewProvider: A closure to provide a custom trailingView for each item (optional).
    public init(
        listCellItemData: [ListCellItemData],
        onSelect: @escaping (ListCellItemData) -> Void,
        @ViewBuilder badgeViewProvider: ((ListCellItemData) -> BadgeView?)? = nil, // Optional
        @ViewBuilder trailingViewProvider: ((ListCellItemData) -> TrailingView?)? = nil // Optional
    ) {
        self.listCellItemData = listCellItemData
        self.onSelect = onSelect
        self.badgeViewProvider = badgeViewProvider
        self.trailingViewProvider = trailingViewProvider
    }
    
    /// The body of the view that renders each list cell using a `ForEach` loop.
    public var body: some View {
        ForEach(listCellItemData) { itemData in
            ListCellItemView(
                listCellItemData: itemData,
                badgeView: {
                    // Provide the badgeView for this cell if available
                    badgeViewProvider?(itemData) ?? EmptyView() // Provide an EmptyView if no badge is provided
                },
                trailingView: {
                    // Provide the trailingView for this cell if available
                    trailingViewProvider?(itemData) ?? EmptyView() // Provide an EmptyView if no trailing view is provided
                }
            ) { selectedItem in
                onSelect(selectedItem)
            }
        }
    }
}

ListCellContainerView(
    listCellItemData: someDataList,
    onSelect: { selectedItem in
        // Handle selection here
    },
    badgeViewProvider: { itemData in
        // Provide the custom badge view for each item, e.g., based on itemData
        ListCellBadgeIndicatorView(actionCount: itemData.actionCount)
    },
    trailingViewProvider: { itemData in
        // Provide the custom trailing view, e.g., Chevron icon
        ListCellIconView(imageName: ComponentConstants.Images.chevron)
    }
)
