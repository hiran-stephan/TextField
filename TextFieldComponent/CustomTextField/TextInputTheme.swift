//
//  TextInputTheme.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 30/08/24.
//

import Foundation
import SwiftUI


// Constants for Colors, Spacing, and Fonts
struct TextInputTheme {
    struct Colors {
        static let borderColor = Color.gray
        static let errorColor = Color.red
        static let backgroundColor = Color(UIColor.systemBackground)
        static let primaryTextColor = Color.primary
        static let disabledTextColor = Color.gray
    }

    struct Spacing {
        static let textFieldHeight: CGFloat = 44
        static let textFieldPadding: CGFloat = 8
        static let labelHeight: CGFloat = 24
        static let iconSize: CGFloat = 16
        static let iconPadding: CGFloat = 8
        static let leadingTextFieldPadding: CGFloat = 16
        static let errorTextTopPadding: CGFloat = 4
        static let containerPadding: CGFloat = 16
        static let cornerRadius: CGFloat = 8
    }

    struct Fonts {
        static let labelFont = Font.body
        static let errorFont = Font.caption
    }
}

