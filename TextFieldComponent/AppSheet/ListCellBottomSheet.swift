//
//  ListCellBottomSheet.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 12/09/24.
//

import Foundation
import SwiftUI

/// Enum representing different bottom sheets within the list cell context. Each case defines
/// a different sheet with associated views and content.
enum ListCellBottomSheet: String, Identifiable, BottomSheetEnum {
    case sheetOne
    case sheetTwo
    
    /// Unique identifier for each bottom sheet, based on its raw value.
    var id: String { rawValue }

    /// Provides the content view for each bottom sheet, switching based on the specific case.
    /// - Parameter coordinator: The `BottomSheetCoordinator` used to handle sheet transitions.
    /// - Returns: A `View` representing the content of the sheet.
    @ViewBuilder
    func view(coordinator: BottomSheetCoordinator<ListCellBottomSheet>) -> some View {
        switch self {
        case .sheetOne:
            sheetOneView()
        case .sheetTwo:
            sheetTwoView(coordinator: coordinator)
        }
    }
    
    // MARK: - View Components
    /// View content for the first bottom sheet (`sheetOne`). It includes a header and a list of items.
    /// - Returns: A `View` representing the first sheet content.
    @ViewBuilder
    private func sheetOneView() -> some View {
        VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
            
            // Header view for the bottom sheet.
            ListCellBottomSheetHeaderView(text: "Need more help?")
            
            // List of cell items displayed within this bottom sheet.
            ListCellContainerView(listCellItemData: sheetOneListData)
                .listStyle(PlainListStyle())

            Spacer() // Pushes the content to the top
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    /// View content for the second bottom sheet (`sheetTwo`). It includes a text description and a button
    /// to navigate back to the first sheet.
    /// - Parameter coordinator: The `BottomSheetCoordinator` to manage sheet transitions.
    /// - Returns: A `View` representing the second sheet content.
    @ViewBuilder
    private func sheetTwoView(coordinator: BottomSheetCoordinator<ListCellBottomSheet>) -> some View {
        VStack {
            Text("This is Sheet Two")
                .padding()
            // Button to navigate back to the first sheet.
            BottomSheetButton(coordinator: coordinator, nextSheet: .sheetOne, title: "Go back to Sheet One")
        }
    }
    
    // MARK: - Helper Methods
    /// Provides the list data for the first bottom sheet, with predefined `ListCellItemData` entries.
    /// - Returns: An array of `ListCellItemData` objects representing the items in the list.
    private var sheetOneListData: [ListCellItemData] {
        return [
            ListCellItemData(textPrimary: "Locations", textSecondary: "please add", leftIconName: "mappin.and.ellipse", actionCount: "1"),
            ListCellItemData(textPrimary: "Help", leftIconName: "questionmark.circle"),
            ListCellItemData(textPrimary: "About", leftIconName: "info.circle"),
            ListCellItemData(textPrimary: "Mobile Privacy Policy", leftIconName: "shield"),
            ListCellItemData(textPrimary: "Mobile Online Security", leftIconName: "lock.shield"),
            ListCellItemData(textPrimary: "Mobile Terms", leftIconName: "doc.text")
        ]
    }
    
    /// Creates a header view for the bottom sheet, containing a customizable text label.
    /// - Parameter text: The header text displayed at the top of the bottom sheet.
    /// - Returns: A `View` representing the header content.
    @ViewBuilder
    private func ListCellBottomSheetHeaderView(text: String) -> some View {
        HStack(alignment: .center, spacing: BankingTheme.spacing.noPadding) {
            Text(text)
                .font(BankingTheme.typography.bodySemiBold.font)
                .foregroundColor(BankingTheme.colors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .padding(.horizontal, BankingTheme.dimens.medium)
        .padding(.top, BankingTheme.dimens.extraExtraLarge)
        .padding(.bottom, BankingTheme.dimens.smallMedium)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}




/// A container view for displaying a list of `ListCellItemView` components, which are rendered
/// from the provided list of `ListCellItemData`.
public struct ListCellContainerView: View {
    // An array of data objects representing each list cell.
    let listCellItemData: [ListCellItemData]
    
    /// Initializes the `ListCellContainerView` with a list of `ListCellItemData`.
    /// - Parameter listCellItemData: The array of data for each list cell.
    public init(listCellItemData: [ListCellItemData]) {
        self.listCellItemData = listCellItemData
    }
    
    /// The body of the view that renders each list cell using a `ForEach` loop.
    public var body: some View {
        ForEach(listCellItemData) { itemData in
            ListCellItemView(listCellItemData: itemData)
        }
    }
}

/// Data model for a list cell item, containing primary text, secondary text, icons, and more.
public struct ListCellItemData: Identifiable {
    // Unique identifier for each list cell item.
    public let id = UUID()
    
    // Primary text displayed in the list cell.
    public let textPrimary: String
    
    // Optional secondary text displayed below the primary text.
    public let textSecondary: String?
    
    // Optional icon name to be displayed on the left side of the cell.
    public let showLeftIcon: String?
    
    // Optional icon name for the right side of the cell.
    public let rightIconName: String?
    
    // Optional icon name for the left side of the cell.
    public let leftIconName: String?
    
    // Accessibility text for the right icon.
    public let rightIconAccessibilityText: String?
    
    // Accessibility text for the left icon.
    public let leftIconAccessibilityText: String?
    
    // Optional number badge or count indicator for the list cell.
    public let actionCount: String?
    
    /// Initializes the `ListCellItemData` with various optional parameters for customization.
    /// - Parameters:
    ///   - textPrimary: The main text for the list cell.
    ///   - textSecondary: Optional secondary text.
    ///   - showLeftIcon: Optional left icon.
    ///   - rightIconName: Optional right icon.
    ///   - leftIconName: Optional left icon.
    ///   - rightIconAccessibilityText: Accessibility description for the right icon.
    ///   - leftIconAccessibilityText: Accessibility description for the left icon.
    ///   - actionCount: Optional badge or count indicator.
    public init(textPrimary: String,
                textSecondary: String? = nil,
                showLeftIcon: String? = nil,
                rightIconName: String? = nil,
                leftIconName: String? = nil,
                rightIconAccessibilityText: String? = nil,
                leftIconAccessibilityText: String? = nil,
                actionCount: String? = nil) {
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
        self.showLeftIcon = showLeftIcon
        self.rightIconName = rightIconName
        self.leftIconName = leftIconName
        self.rightIconAccessibilityText = rightIconAccessibilityText
        self.leftIconAccessibilityText = leftIconAccessibilityText
        self.actionCount = actionCount
    }
}

/// A view representing an individual list cell, displaying primary text, optional secondary text,
/// and optional icons with customizable badges.
public struct ListCellItemView: View {
    // Data for the specific list cell.
    let listCellItemData: ListCellItemData
    
    /// Initializes the `ListCellItemView` with its corresponding data.
    /// - Parameter listCellItemData: The data object containing details for this list cell.
    public init(listCellItemData: ListCellItemData) {
        self.listCellItemData = listCellItemData
    }
    
    /// The body of the list cell, displaying its content within a button.
    public var body: some View {
        Button {
            // TODO: button action
        } label: {
            VStack(spacing: BankingTheme.spacing.noPadding) {
                HStack(alignment: .center, spacing: BankingTheme.dimens.small) {
                    // Leading Image Placeholder
                    ListCellIconView(imageName: "chevron", padding: BankingTheme.dimens.small)
                    
                    // Primary and Secondary Text
                    listCellTextContent(listCellItemData: listCellItemData)
                    
                    Spacer()
                    
                    // Badge or Count Indicator View
                    listCellBadgeIndicatorView(listCellItemData: listCellItemData)

                    // Trailing Image Placeholder
                    ListCellIconView(imageName: "chevron")
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(BankingTheme.dimens.medium)
            }
        }
        .buttonStyle(ListCellButtonModifier())
        .ignoresSafeArea()
    }
    
    /// A subview that renders the primary and optional secondary text for the list cell.
    @ViewBuilder
    private func listCellTextContent(listCellItemData: ListCellItemData) -> some View {
        VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
            Text(listCellItemData.textPrimary)
                .typography(BankingTheme.typography.body)
                .foregroundColor(BankingTheme.colors.textPrimary)
                .frame(maxHeight: listCellItemData.textSecondary == nil ? .infinity : nil)
            
            if let textSecondary = listCellItemData.textSecondary {
                Text(textSecondary)
                    .typography(BankingTheme.typography.bodySmall)
                    .foregroundColor(BankingTheme.colors.textSecondary)
            }
        }
    }
    
    /// A subview that renders a badge or count indicator for the list cell, if available.
    @ViewBuilder
    private func listCellBadgeIndicatorView(listCellItemData: ListCellItemData) -> some View {
        if let trailingNumber = listCellItemData.actionCount {
            HStack {
                Text(trailingNumber)
                    .font(BankingTheme.typography.caption.font)
                    .frame(width: BankingTheme.dimens.mediumLarge, height: BankingTheme.dimens.medium)
                    .foregroundColor(BankingTheme.colors.textPrimary)
                    .background(Color(hex: 0xFFFCCDDF2))
                    .cornerRadius(BankingTheme.dimens.mediumLarge)
            }
        }
    }
}

/// A custom button style for the list cell button, adding a divider at the bottom and handling
/// background color changes when pressed.
struct ListCellButtonModifier: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: ListCellTheme.cellHeight)
            .overlay(
                Divider()
                    .frame(height: BankingTheme.spacing.stroke)
                    .background(BankingTheme.colors.borderDefault)
                    .padding(.horizontal, BankingTheme.dimens.medium), alignment: .bottom
            )
            .background(configuration.isPressed ? BankingTheme.colors.pressed : BankingTheme.colors.surfaceVariant)
    }
}

/// A theme structure containing shared values used in the list cell's appearance.
struct ListCellTheme {
    static let cellHeight = 76.0
}

/// A reusable view for displaying icons in list cells, with customizable padding.
public struct ListCellIconView: View {
    let imageName: String
    let padding: CGFloat
    
    /// Initializes the `ListCellIconView` with an image name and optional padding.
    /// - Parameters:
    ///   - imageName: The name of the image to display.
    ///   - padding: The padding around the image (defaults to no padding).
    public init(imageName: String, padding: CGFloat = BankingTheme.spacing.noPadding) {
        self.imageName = imageName
        self.padding = padding
    }
    
    /// The body of the view, rendering the image with the specified padding.
    public var body: some View {
        ZStack {
            ComponentImage(imageName, resizable: true)
                .frame(width: BankingTheme.dimens.large, height: BankingTheme.dimens.large)
                .padding(padding)
        }
    }
}


