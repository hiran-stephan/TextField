
import Foundation

struct ListCellBottomSheetData {
    let title: String
    let titleAccessibilityText: String
    let menuActions: [ListCellData]
}

struct ListCellData {
    let actionCellId: String
    let leadingIcon: String?
    let trailingIcon: String?
    let primaryLabel: String
    let secondaryLabel: String?
    let leadingIconAccessibilityText: String?
    let trailingIconAccessibilityText: String?
    let route: String
}

extension PreSignonMenuPresenter {
    func toListCellBottomSheetData(locale: Locale) -> ListCellBottomSheetData {
        return ListCellBottomSheetData(
            title: self.menuTitle.localized(locale: locale),
            titleAccessibilityText: self.menuTitleAccessibilityText.localized(locale: locale),
            menuActions: self.menuActionList.map { item in
                ListCellData(
                    actionCellId: item.id,
                    leadingIcon: item.leadingIcon?.localized(locale: locale).flatMap { mapToDrawableResource($0) },
                    trailingIcon: item.trailingIcon?.localized(locale: locale).flatMap { mapToDrawableResource($0) },
                    primaryLabel: item.primaryText.localized(locale: locale),
                    secondaryLabel: item.secondaryText?.localized(locale: locale),
                    leadingIconAccessibilityText: item.leadingIcon?.localizedAccessibility(locale: locale),
                    trailingIconAccessibilityText: item.trailingIcon?.localizedAccessibility(locale: locale),
                    route: item.actionLink
                )
            }
        )
    }
    
    private func mapToDrawableResource(_ iconName: String) -> String {
        // Implement mapping logic to get the drawable resource name or path
        return iconName
    }
}

// Usage Example
// let bottomSheetData = presenter.toListCellBottomSheetData(locale: Locale.current)
