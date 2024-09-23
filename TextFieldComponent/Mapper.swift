//
//  Mapper.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 18/09/24.
//

import Foundation

struct ListCellDataMapper {
    /// Maps the data from `PreSignonMenuPresenter` to `ListCellBottomSheetData`.
    ///
    /// - Parameter preSignonMenuPresenter: The presenter containing menu title, accessibility text, and actions.
    /// - Returns: A `ListCellBottomSheetData` object populated with localized data directly from the presenter.
    static func map(preSignonMenuPresenter: PreSignonMenuPresenter) -> ListCellBottomSheetData {
        // Extract localized menu title and accessibility text directly from the presenter
        let menuTitle = preSignonMenuPresenter.menuTitle
        let menuTitleAccessibilityText = preSignonMenuPresenter.menuTitleAccessibilityText

        // Map the menu actions to ListCellItemData
        let listCellItemData = preSignonMenuPresenter.menuActionList.map { menuAction in
            ListCellItemData(
                textPrimary: menuAction.primaryText, // No need to specify .en or .fr
                textSecondary: menuAction.secondaryText, // Presenter should handle localization
                rightIconName: menuAction.trailingIcon, // Presenter returns the correct value
                leftIconName: menuAction.leadingIcon ?? "", // Provide default empty string if nil
                rightIconAccessibilityText: menuAction.trailingIconAccessibility, // Already localized
                leftIconAccessibilityText: menuAction.leadingIconAccessibility, // Already localized
                actionLink: menuAction.actionLink,
                actionType: menuAction.actionType.rawValue
            )
        }

        // Return the new ListCellBottomSheetData
        return ListCellBottomSheetData(
            title: menuTitle,
            titleAccessibilityText: menuTitleAccessibilityText,
            menuActions: listCellItemData
        )
    }
}


public struct ListCellBottomSheetData {
    public var title: String
    public var titleAccessibilityText: String
    public var menuActions: [ListCellItemData]
    
    // Initializer
    public init(title: String, titleAccessibilityText: String, menuActions: [ListCellItemData]) {
        self.title = title
        self.titleAccessibilityText = titleAccessibilityText
        self.menuActions = menuActions
    }
}
@State private var bottomSheetData: ListCellBottomSheetData = ListCellBottomSheetData(
        title: "",
        titleAccessibilityText: "",
        menuActions: []
    ) // Initial placeholder value for state variable


    .onAppear {
        viewModel.attachViewModel(navigator: LoginPageNavigatorImpl())

        let preSignonMenuPresenter = viewModel.createPreSignonMenuPresenter()

        // Use the updated ListCellDataMapper to get the ListCellBottomSheetData
        let bottomSheetData = ListCellDataMapper.map(
            preSignonMenuPresenter: preSignonMenuPresenter,
            locale: locale
        )

        // Pass the ListCellBottomSheetData to ListCellBottomSheet
        coordinator.showBottomSheet(data: bottomSheetData)
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
