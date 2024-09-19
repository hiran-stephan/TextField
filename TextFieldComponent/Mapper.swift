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
struct ListMenuAction: Decodable {
    let id: String
    let primaryText: [String: String] // Localized primary text
    let secondaryText: [String: String]? // Optional localized secondary text
    let actionLink: String
    let actionType: ActionType
    let leadingIcon: LocalizedText? // Optional leading icon
    let trailingIcon: LocalizedText? // Optional trailing icon
    
    // CodingKeys to map JSON keys to Swift property names
    enum CodingKeys: String, CodingKey {
        case id
        case primaryText = "primary_text"
        case secondaryText = "secondary_text"
        case actionLink = "action_link"
        case actionType = "action_type"
        case leadingIcon = "leading_icon"
        case trailingIcon = "trailing_icon"
    }
    
    // Static function to load ListMenuActions from JSON
    static func loadMenuActionsFromJSON() -> [ListMenuAction] {
        let jsonData = """
        [
          {
            "id": "privacy_policy",
            "primary_text": {
              "en": "Mobile Privacy Policy",
              "fr": "Politique de confidentialité mobile"
            },
            "action_link": "app://privacy",
            "action_type": "webLink",
            "leading_icon": {
              "en": "shield.png",
              "fr": "bouclier.png"
            },
            "trailing_icon": {
              "en": "chevron_right.png",
              "fr": "chevron_droit.png"
            }
          },
          {
            "id": "online_security",
            "primary_text": {
              "en": "Mobile Online Security",
              "fr": "Sécurité en ligne mobile"
            },
            "action_link": "app://security",
            "action_type": "webLink",
            "leading_icon": {
              "en": "lock_shield.png",
              "fr": "verrou_bouclier.png"
            },
            "trailing_icon": {
              "en": "chevron_right.png",
              "fr": "chevron_droit.png"
            }
          },
          {
            "id": "terms_conditions",
            "primary_text": {
              "en": "Mobile Terms",
              "fr": "Conditions d'utilisation mobile"
            },
            "action_link": "app://terms",
            "action_type": "webLink",
            "leading_icon": {
              "en": "doc_text.png",
              "fr": "doc_texte.png"
            },
            "trailing_icon": {
              "en": "chevron_right.png",
              "fr": "chevron_droit.png"
            }
          }
        ]
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        do {
            let menuActions = try decoder.decode([ListMenuAction].self, from: jsonData)
            return menuActions
        } catch {
            print("Failed to decode JSON: \(error)")
            return []
        }
    }
}

// Struct representing localized text (for icons, labels, etc.)
struct LocalizedText: Decodable {
    let text: [String: String] // Localized versions of the text

    // CodingKeys to map JSON keys to Swift property names (empty, since we are decoding directly)
    private enum CodingKeys: String, CodingKey {
        case en, fr // You can add more languages if needed
    }

    // Custom initializer to decode the localized text directly as a dictionary
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var textDict = [String: String]()
        if let enText = try container.decodeIfPresent(String.self, forKey: .en) {
            textDict["en"] = enText
        }
        if let frText = try container.decodeIfPresent(String.self, forKey: .fr) {
            textDict["fr"] = frText
        }
        self.text = textDict
    }

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
enum ActionType: String, Decodable {
    case deeplink = "DEEPLINK"
    case external = "EXTERNAL"
    case inApp = "IN_APP"
    case webLink = "webLink"
}


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
//let listCellData = ListCellDataMapper.toListCellData(listMenuAction: helpMenuAction, locale: "en")

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
