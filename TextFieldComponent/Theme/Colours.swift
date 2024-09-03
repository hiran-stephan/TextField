//
//  Colours.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 03/09/24.
//

import Foundation
import SwiftUI

public struct Colours {
    public let primary: Color
    public let onPrimary: Color
    public let secondary: Color
    public let onSecondary: Color
    public let tertiary: Color
    public let onTertiary: Color
    public let background: Color
    public let onBackground: Color
    public let surface: Color
    public let surfaceVariant: Color
    public let onSurface: Color
    public let onSurfaceVariant: Color
    public let borderDefault: Color
    public let borderVariant: Color
    public let pressed: Color
    public let textPrimary: Color
    public let textSecondary: Color
    public let textReversed: Color
    public let textPressed: Color
    public let error: Color
    public let onError: Color
    public let errorBorder: Color
    public let errorContainer: Color
    public let onErrorContainer: Color
    public let warning: Color
    public let onWarning: Color
    public let warningBorder: Color
    public let info: Color
    public let onInfo: Color
    public let infoBorder: Color
    public let success: Color
    public let onSuccess: Color
    public let successBorder: Color
    public let illustrationPink: Color
    public let illustrationPinkShadow: Color
    public let illustrationTeal: Color
    public let illustrationTealShadow: Color
    public let illustrationGrey: Color
    public let illustrationGreyShadow: Color
    public let disabled: Color
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
