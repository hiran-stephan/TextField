import Foundation
import SwiftUI
import Umbrella
import Theme
import Components
import Koin

extension AccountPreferencesAccountPresenter {
    func toAccountPreferenceCardData() -> AccountPreferenceCardData {
        let badgeIndicators: [BadgeIndicatorData] = isHidden
            ? []
            : [BadgeIndicatorData(type: .passiveReversed, text: "Hidden")]

        return AccountPreferenceCardData(
            primaryText: itemFirstRowLabel,
            secondaryText: itemSecondRowLabel,
            showMiniCard: shouldShowMiniCard,
            badgeIndicators: badgeIndicators
        )
    }
}
