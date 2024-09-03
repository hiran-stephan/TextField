//
//  USBankingColors.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 03/09/24.
//

import Foundation
import SwiftUI

struct USBankingColors {
    static let Blue = Color(hex: 0xFFCCDFD2)
    static let BlueLight = Color(hex: 0xFFDEE9F7)
    static let BrandBurgundy = Color(hex: 0xFF8D1D41)
    static let BrandCharcoal = Color(hex: 0xFF3B3E3E)
    static let BrandLightGrey = Color(hex: 0xFFE2F3F2)
    static let BrandRed = Color(hex: 0xFFC41F3E)
    static let BrandWhite = Color(hex: 0xFFFFFFFF)
    static let Gold = Color(hex: 0xFFF6EF6E)
    static let Green = Color(hex: 0xFFE7F2ED)
    static let Grey = Color(hex: 0xFFD9D9D6)
    static let GreyLight = Color(hex: 0xFFE2F3F2)
    static let Pink = Color(hex: 0xFFFED4D8)
    static let PinkLight = Color(hex: 0xFFF5E3E8)
    static let PinkStatusBackground = Color(hex: 0xFFFAF1F3)
    static let Teal = Color(hex: 0xFFBCE4E3)
    static let TealLight = Color(hex: 0xFFD3EDEE)
    static let TextGrey = Color(hex: 0xFF606366)
    static let BorderDefault = Color(hex: 0xFFD9D9D6)
    static let BorderError = Color(hex: 0xFFFBBBCC)
    static let BorderInfo = Color(hex: 0xFF9BBFE0)
    static let BorderSuccess = Color(hex: 0xFF76B297)
    static let BorderWarning = Color(hex: 0xFFFDD364)
    static let Pressed = Color(hex: 0xFFE8E6E6)
    static let OnInfo = Color(hex: 0xFF0767A8)
    static let OnSuccess = Color(hex: 0xFF739795)
    static let OnWarning = Color(hex: 0xFFFA35F00)
    static let disabled = Color(hex: 0xBBBCBC)
}

func createUSBankingColorsLight() -> Colours {
    return Colours(
        primary: USBankingColors.BrandRed,
        onPrimary: USBankingColors.BrandWhite,
        secondary: USBankingColors.BrandRed,
        onSecondary: USBankingColors.BrandWhite,
        tertiary: USBankingColors.BrandBurgundy,
        onTertiary: USBankingColors.BrandWhite,
        background: USBankingColors.BrandWhite,
        onBackground: USBankingColors.BrandCharcoal,
        surface: USBankingColors.BrandLightGrey,
        surfaceVariant: USBankingColors.BrandWhite,
        onSurface: USBankingColors.BrandCharcoal,
        onSurfaceVariant: USBankingColors.TextGrey,
        borderDefault: USBankingColors.BorderDefault,
        borderVariant: USBankingColors.TextGrey,
        pressed: USBankingColors.Pressed,
        textPrimary: USBankingColors.BrandCharcoal,
        textSecondary: USBankingColors.TextGrey,
        textReversed: USBankingColors.BrandWhite,
        textPressed: USBankingColors.BrandBurgundy,
        error: USBankingColors.BrandBurgundy,
        onError: USBankingColors.BrandWhite,
        errorBorder: USBankingColors.BorderError,
        errorContainer: USBankingColors.Pink,
        onErrorContainer: USBankingColors.BrandCharcoal,
        warning: USBankingColors.Gold,
        onWarning: USBankingColors.OnWarning,
        warningBorder: USBankingColors.BorderWarning,
        info: USBankingColors.BlueLight,
        onInfo: USBankingColors.OnInfo,
        infoBorder: USBankingColors.BorderInfo,
        success: USBankingColors.Green,
        onSuccess: USBankingColors.OnSuccess,
        successBorder: USBankingColors.BorderSuccess,
        illustrationPink: USBankingColors.PinkLight,
        illustrationPinkShadow: USBankingColors.Pink,
        illustrationTeal: USBankingColors.TealLight,
        illustrationTealShadow: USBankingColors.Teal,
        illustrationGrey: USBankingColors.GreyLight,
        illustrationGreyShadow: USBankingColors.Grey,
        disabled: USBankingColors.disabled
    )
}


extension Theme {
    public static let USDark = {
        return Theme(
            mode: .dark,
            colors: createUSBankingColorsLight(),
            shapes: defaultShapes,
            dimens: UIDevice.current.userInterfaceIdiom == .pad ? tabletDimens : phoneDimens,
            typography: SystemFont().defaultTypography,
            spacing: defaultSpacing
        )
    }()

    public static let USLight = {
        return Theme(
            mode: .light,
            colors: createUSBankingColorsLight(),
            shapes: defaultShapes,
            dimens: UIDevice.current.userInterfaceIdiom == .pad ? tabletDimens : phoneDimens,
            typography: SystemFont().defaultTypography,
            spacing: defaultSpacing
        )
    }()
}
