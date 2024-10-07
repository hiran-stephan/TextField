//
//  TabBarStyle.swift
//  SecondaryTabBar
//
//  Created by Hiran Stephan on 06/10/24.
//

import Foundation
import SwiftUI

/// The `TabBarStyle` is used to configure the visual appearance of a tab bar based on whether it has a border and a rounded shape.
///
/// - Parameters:
///   - borderColor: The color of the border around the tab bar. Defaults to clear if no border is applied.
///   - backgroundColor: The background color of the tab bar. Adjusts based on whether a border is present.
///   - cornerRadius: The corner radius of the tab bar, providing rounded corners when specified.
///   - borderStroke: The width of the border stroke around the tab bar.
struct TabBarStyle {

    var borderColor: Color
    var backgroundColor: Color
    var cornerRadius: CGFloat
    var borderStroke: CGFloat

    init(hasBorder: Bool, isRoundedShape: Bool) {
        
        borderColor = hasBorder ? BankingTheme.colors.borderDefault : Color.clear
        backgroundColor = hasBorder ? BankingTheme.colors.background : BankingTheme.colors.illustrationGreyShadow
        cornerRadius = isRoundedShape ? BankingTheme.dimens.smallMedium : BankingTheme.spacing.noPadding
        borderStroke = hasBorder ? BankingTheme.spacing.stroke : BankingTheme.spacing.noPadding
    }
}


