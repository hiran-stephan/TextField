//
//  ListCellItemView.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 01/10/24.
//

import Foundation
import SwiftUI

public struct ListCellItemView<ContentView: View>: View {
    let listCellItemData: ListCellItemData
    let badgeView: ContentView   // Placeholder view for the badge section
    let trailingView: ContentView // Placeholder view for the trailing image section

    static let minCellHeight: CGFloat = 76.0

    var pressedColor: Color?
    var defaultColor: Color?
    var needsLargerPadding: Bool = false

    // A closure that is called when the button is tapped.
    let onSelect: ((ListCellItemData) -> Void)?

    // Initializes the `ListCellItemView` with its corresponding data.
    public init(
        listCellItemData: ListCellItemData,
        pressedColor: Color? = BankingTheme.colors.pressed,
        defaultColor: Color? = BankingTheme.colors.surfaceVariant,
        needsLargerPadding: Bool = false,
        onSelect: ((ListCellItemData) -> Void)? = nil,
        @ViewBuilder badgeView: () -> ContentView, // Placeholder for badge view
        @ViewBuilder trailingView: () -> ContentView // Placeholder for trailing view
    ) {
        self.listCellItemData = listCellItemData
        self.pressedColor = pressedColor
        self.defaultColor = defaultColor
        self.needsLargerPadding = needsLargerPadding
        self.onSelect = onSelect
        self.badgeView = badgeView() // Assign the badge view
        self.trailingView = trailingView() // Assign the trailing view
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

                    // Badge View Placeholder
                    badgeView

                    // Trailing Image Placeholder replaced with the custom trailing view
                    trailingView
                        .padding(needsLargerPadding ? BankingTheme.dimens.mediumLarge : BankingTheme.dimens.medium)
                }
                .frame(minHeight: ListCellItemView.minCellHeight)
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
