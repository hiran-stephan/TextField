//
//  Mapper.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 18/09/24.
//

import Foundation

import Foundation

/// Data model for a list cell item, containing primary text, secondary text, icons, action links, and more.
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
    
    // Action link (deeplink or URL) for the cell item.
    public let actionLink: String?
    
    // Action type (e.g., "deeplink", "webLink").
    public let actionType: String?
    
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
    ///   - actionLink: Action link (e.g., deeplink or URL).
    ///   - actionType: Action type (e.g., "deeplink", "webLink").
    public init(textPrimary: String,
                textSecondary: String? = nil,
                showLeftIcon: String? = nil,
                rightIconName: String? = nil,
                leftIconName: String? = nil,
                rightIconAccessibilityText: String? = nil,
                leftIconAccessibilityText: String? = nil,
                actionCount: String? = nil,
                actionLink: String? = nil,
                actionType: String? = nil) {
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
        self.showLeftIcon = showLeftIcon
        self.rightIconName = rightIconName
        self.leftIconName = leftIconName
        self.rightIconAccessibilityText = rightIconAccessibilityText
        self.leftIconAccessibilityText = leftIconAccessibilityText
        self.actionCount = actionCount
        self.actionLink = actionLink
        self.actionType = actionType
    }
}

struct ListCellDataMapper {

    /// Converts ViewModel data into `ListCellItemData` based on the current language.
    /// - Parameters:
    ///   - viewModel: The ViewModel data to be converted.
    ///   - language: The selected language for localization (e.g., "en" or "fr").
    /// - Returns: An array of `ListCellItemData`.
    static func map(from viewModel: [YourViewModel], for language: String = "en") -> [ListCellItemData] {
        return viewModel.map { data in
            ListCellItemData(
                textPrimary: data.primaryText[language] ?? data.primaryText["en"] ?? "",
                textSecondary: nil, // If there is no secondary text in your ViewModel, it can be set to `nil`
                leftIconName: data.leadingIcon.iconPath, // Path to the left icon from the ViewModel
                leftIconAccessibilityText: data.leadingIcon.accessibility[language] ?? data.leadingIcon.accessibility["en"], // Localized accessibility text
                actionLink: data.actionLink, // Action link from the ViewModel
                actionType: data.actionType // Action type from the ViewModel
            )
        }
    }
}

let helpViewModel = YourViewModel(
    id: "help",
    primaryText: [
        "en": "Help Centre",
        "fr": "Centre d'aide"
    ],
    actionLink: "cibebanking://helpcentre",
    actionType: "deeplink",
    leadingIcon: YourViewModel.LeadingIcon(
        iconPath: "path-to-file.png",
        accessibility: [
            "en": "Description of image",
            "fr": "French description"
        ]
    )
)

let aboutViewModel = YourViewModel(
    id: "about",
    primaryText: [
        "en": "About Us",
        "fr": "À propos de nous"
    ],
    actionLink: "cibebanking://about",
    actionType: "webLink",
    leadingIcon: YourViewModel.LeadingIcon(
        iconPath: "path-to-about.png",
        accessibility: [
            "en": "About Us image description",
            "fr": "Description de l'image à propos de nous"
        ]
    )
)

// Map ViewModel data to `ListCellItemData`
let listCellData = ListCellDataMapper.map(from: [helpViewModel, aboutViewModel], for: "en")

// Example usage in your bottom sheet
let bottomSheet = ListCellBottomSheet.sheetOne
bottomSheet.view(coordinator: yourCoordinator, listCellItemData: listCellData)

struct YourViewModel {
    let id: String
    let primaryText: [String: String] // Dictionary for localized text
    let actionLink: String
    let actionType: String
    let leadingIcon: LeadingIcon

    struct LeadingIcon {
        let iconPath: String
        let accessibility: [String: String] // Dictionary for localized accessibility descriptions
    }
}
