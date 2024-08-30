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

// Usage: let color = Color(hex: "#FF5733")
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
