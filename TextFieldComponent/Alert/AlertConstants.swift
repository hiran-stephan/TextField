//
//  AlertConstants.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 25/09/24.
//

import Foundation
import SwiftUI

// MARK: - Alert Constants
/// Contains commonly used values such as padding, opacity, font sizes, and colors.
enum AlertConstants {
    static let backgroundOpacity: Double = 0.4
    static let cornerRadius: CGFloat = 15
    static let shadowRadius: CGFloat = 10
    static let padding: CGFloat = 10
    static let topPadding: CGFloat = 20
    static let buttonSpacing: CGFloat = 10
    static let alertContainerHorizontalPadding: CGFloat = 15
    static let alertTitleFont: Font = .headline
    static let alertMessageFont: Font = .body
    
    // Colors matching native iOS alert colors
    static let backgroundColor = Color(UIColor.systemBackground).opacity(backgroundOpacity)
    static let alertBackgroundColor = Color(UIColor.systemBackground)
    static let defaultButtonBackground = Color.accentColor
    static let destructiveButtonBackground = Color(UIColor.systemRed)
    static let cancelButtonBackground = Color(UIColor.systemGray)
    static let buttonForegroundColor = Color.primary
    static let cancelButtonForegroundColor = Color(UIColor.systemRed)
}
