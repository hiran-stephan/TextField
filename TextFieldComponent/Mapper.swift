//
//  Mapper.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 18/09/24.
//

import Foundation

struct ListCellDataMapper {

    /// Converts ViewModel data (ListMenuAction) into `ListCellItemData` based on the current locale.
    /// - Parameters:
    ///   - listMenuAction: The ViewModel data to be converted (similar to ListMenuAction in Kotlin).
    ///   - locale: The locale for localization (e.g., "en", "fr").
    /// - Returns: A `ListCellItemData` object populated with localized values.
    static func toListCellData(listMenuAction: ListMenuAction, locale: String) -> ListCellItemData {
        return ListCellItemData(
            // Primary text from ListMenuAction
            textPrimary: listMenuAction.primaryText[locale] ?? listMenuAction.primaryText["en"] ?? "",
            
            // Secondary text (optional)
            textSecondary: listMenuAction.secondaryText?[locale] ?? listMenuAction.secondaryText?["en"],
            
            // Leading icon (left icon)
            leftIconName: listMenuAction.leadingIcon?.localized(locale) ?? "",
            
            // Right icon mapped to a drawable resource (if available)
            rightIconName: listMenuAction.trailingIcon?.localized(locale),
            
            // Accessibility text for the right icon (localized)
            rightIconAccessibilityText: listMenuAction.trailingIcon?.localizedAccessibility(locale),
            
            // Accessibility text for the left icon (localized)
            leftIconAccessibilityText: listMenuAction.leadingIcon?.localizedAccessibility(locale),
            
            // Action link and type
            actionLink: listMenuAction.actionLink,
            actionType: listMenuAction.actionType.rawValue
        )
    }
}



// Struct representing the ListMenuAction
struct ListMenuAction {
    let id: String
    let primaryText: [String: String] // Localized primary text
    let secondaryText: [String: String]? // Optional localized secondary text
    let actionLink: String
    let actionType: ActionType
    let leadingIcon: LocalizedText? // Optional leading icon
    let trailingIcon: LocalizedText? // Optional trailing icon
}

// Struct representing localized text (for icons, labels, etc.)
struct LocalizedText {
    let text: [String: String] // Localized versions of the text

    // Method to get the localized version of the text
    func localized(_ locale: String) -> String? {
        return text[locale] ?? text["en"] // Fallback to English
    }

    // Method to get the localized accessibility text
    func localizedAccessibility(_ locale: String) -> String? {
        return localized(locale) // In this case, we assume accessibility text is the same as the localized text
    }
}

// Enum for action types
enum ActionType: String {
    case deeplink = "DEEPLINK"
    case external = "EXTERNAL"
    case inApp = "IN_APP"
}

// Example data for ListMenuAction
let helpMenuAction = ListMenuAction(
    id: "help",
    primaryText: [
        "en": "Help Centre",
        "fr": "Centre d'aide"
    ],
    secondaryText: nil, // No secondary text provided
    actionLink: "cibebanking://helpcentre",
    actionType: .deeplink,
    leadingIcon: LocalizedText(text: ["en": "help_icon.png", "fr": "icone_aide.png"]),
    trailingIcon: LocalizedText(text: ["en": "chevron_right.png", "fr": "chevron_droit.png"])
)

//let aboutViewModel = YourViewModel(
//    id: "about",
//    primaryText: [
//        "en": "About Us",
//        "fr": "À propos de nous"
//    ],
//    actionLink: "cibebanking://about",
//    actionType: "webLink",
//    leadingIcon: YourViewModel.LeadingIcon(
//        iconPath: "path-to-about.png",
//        accessibility: [
//            "en": "About Us image description",
//            "fr": "Description de l'image à propos de nous"
//        ]
//    )
//)

// Convert ListMenuAction to ListCellItemData using the DataMapper
let listCellData = ListCellDataMapper.toListCellData(listMenuAction: helpMenuAction, locale: "en")

//// Example usage in your bottom sheet
//let bottomSheet = ListCellBottomSheet.sheetOne
//bottomSheet.view(coordinator: yourCoordinator, listCellItemData: listCellData)
//
//struct YourViewModel {
//    let id: String
//    let primaryText: [String: String] // Dictionary for localized text
//    let actionLink: String
//    let actionType: String
//    let leadingIcon: LeadingIcon
//
//    struct LeadingIcon {
//        let iconPath: String
//        let accessibility: [String: String] // Dictionary for localized accessibility descriptions
//    }
//}
