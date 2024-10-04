//
//  ListCellData.swift
//  ListCell
//
//  Created by Hiran Stephan on 03/10/24.
//

import Foundation

/// A model representing data for a list cell, including labels, icons, accessibility text, and routing information.
struct ListCellItemData: Equatable {
    let actionCellId: String?
    let actionPrimaryLabel: String
    let actionSecondaryLabel: String?
    let leadingIconName: String?
    let trailingIconName: String?
    let leadingIconAccessibilityText: String?
    let trailingIconAccessibilityText: String?
    let actionCount: String?
    let data: String?
    let route: String?

    /// Initializes a new instance of `ListCellItemData`.
    /// - Parameters:
    ///   - actionPrimaryLabel: The required primary text label.
    ///   - actionCellId: An optional identifier for the action cell (default is `nil`).
    ///   - actionSecondaryLabel: An optional secondary label (default is `nil`).
    ///   - leadingIconName: An optional name for the leading icon (default is `nil`).
    ///   - trailingIconName: An optional name for the trailing icon (default is `nil`).
    ///   - leadingIconAccessibilityText: Accessibility text for the leading icon (default is `nil`).
    ///   - trailingIconAccessibilityText: Accessibility text for the trailing icon (default is `nil`).
    ///   - actionCount: Optional count or badge text (default is `nil`).
    ///   - data: Optional data associated with the cell (default is `nil`).
    ///   - route: Optional route for deep linking or navigation (default is `nil`).
    init(
        actionCellId: String? = nil,
        actionPrimaryLabel: String,
        actionSecondaryLabel: String? = nil,
        leadingIconName: String? = nil,
        trailingIconName: String? = nil,
        leadingIconAccessibilityText: String? = nil,
        trailingIconAccessibilityText: String? = nil,
        actionCount: String? = nil,
        data: String? = nil,
        route: String? = nil
    ) {
        self.actionPrimaryLabel = actionPrimaryLabel
        self.actionCellId = actionCellId
        self.actionSecondaryLabel = actionSecondaryLabel
        self.leadingIconName = leadingIconName
        self.trailingIconName = trailingIconName
        self.leadingIconAccessibilityText = leadingIconAccessibilityText
        self.trailingIconAccessibilityText = trailingIconAccessibilityText
        self.actionCount = actionCount
        self.data = data
        self.route = route
    }
}

