//
// AccountPreferencesAccountPresenterMapper.swift
//
// Created by Stephan, Hiran on 2024-12-18.
//

import Umbrella
import Components

/// Extension to map `AccountPreferencesAccountPresenter` to `AccountPreferenceCardData`.
extension AccountPreferencesAccountPresenter {
    
    /// Maps the account presenter to a data model `AccountPreferenceCardData`.
    ///
    /// This function converts the presenter's properties into a structured `AccountPreferenceCardData`.
    /// It conditionally includes a badge indicator if the `isHidden` property is `true`.
    ///
    /// - Returns: An instance of `AccountPreferenceCardData` containing:
    ///   - `primaryText`: The first row of label text.
    ///   - `secondaryText`: The second row of label text.
    ///   - `showMiniCard`: A boolean indicating if a mini card should be displayed.
    ///   - `badgeIndicators`: An optional badge indicator for "Hidden" state.
    func toAccountPreferenceCardData() -> AccountPreferenceCardData {
        /// Badge indicators array, conditionally populated if `isHidden` is `true`.
        let badgeIndicators: [BadgeIndicatorData] = isHidden
            ? [BadgeIndicatorData(type: .passiveReversed, text: "Hidden")]
            : []
        
        /// Constructs and returns the account preference card data.
        return AccountPreferenceCardData(
            primaryText: itemFirstRowLabel,
            secondaryText: itemSecondRowLabel,
            showMiniCard: shouldShowMiniCard,
            badgeIndicators: badgeIndicators
        )
    }
}
