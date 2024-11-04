
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
                ListCellItemData(
                    actionCellId: item.id,
                    actionPrimaryLabel: item.primaryText.localized(locale: locale),
                    actionSecondaryLabel: item.secondaryText?.localized(locale: locale) ?? "",
                    leadingIconName: item.leadingIcon?.localized(locale: locale),
                    trailingIconName: item.trailingIcon?.localized(locale: locale),
                    leadingIconAccessibilityText: item.leadingIcon?.localizedAccessibility(locale: locale),
                    trailingIconAccessibilityText: item.trailingIcon?.localizedAccessibility(locale: locale),
                    actionCount: item.count?.localized(locale: locale),
                    data: item.data?.localized(locale: locale),
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
