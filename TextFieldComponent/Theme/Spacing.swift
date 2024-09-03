//
//  Spacing.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 03/09/24.
//

import Foundation

public struct Spacing {
    public let noPadding = 0.0
    public let paddingSmallMicro = 4.0
    public let paddingSmall = 8.0
    public let paddingMicroMedium = 10.0
    public let paddingSmallMedium = 12.0
    public let paddingMedium = 16.0
    public let paddingMediumLarge = 20.0
    public let paddingLarge = 24.0
    public let paddingExtraLarge = 32.0
    public let appBarHeight = 56.0
    public let appBarMinHeight = 64.0
    public let actionIconSize = 44.0
    public let footerHeight = 144.0
    public let stroke = 1.0
    public let halfStroke = 0.5
    public let tileElevation = 3.0
    public let miniCardHeight = 44.0
    public let maxLength = 700.0
    public let floatSizeRef075 = 0.75
    public let linkCellHeight = 72.0
    public let paddingFullEdges = 60.0
    public let buttonMinHeight = 44.0
    public let buttonMinWidth = 331.0
    // TODO: update these and dimensions to align with Android once Android is available
}


extension Theme {
    static let defaultSpacing = {
        return Spacing()
    }()
}
