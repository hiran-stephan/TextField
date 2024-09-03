//
//  Typography.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 03/09/24.
//

import Foundation
import SwiftUI

public struct Typography {
    public let display: TypographyGroup
    public let displaySmall: TypographyGroup
    
    public let headingExtraLarge: TypographyGroup
    public let headingLarge: TypographyGroup
    public let heading: TypographyGroup
    public let headingSmall: TypographyGroup
    public let allCapsHeading: TypographyFont
    
    public let body: TypographyFont
    public let bodySemiBold: TypographyFont
    public let bodySmall: TypographyFont
    public let bodySmallSemiBold: TypographyFont
    
    public let caption: TypographyFont
    public let captionSemiBold: TypographyFont
}

public struct TypographyGroup {
    public let medium: TypographyFont
    public let small: TypographyFont
}

public struct TypographyFont {
    public let font: Font
    public let lineSpacing: CGFloat
    public let allCaps: Bool
}

extension TypographyFont {
    static func create(name: String, size: CGFloat, lineHeight: CGFloat, allCaps: Bool = false) -> TypographyFont {
        return TypographyFont(
            font: .fixed(name, size: size),
            lineSpacing: lineHeight - size,
            allCaps: allCaps
        )
    }
}

extension CustomFont {
    var defaultTypography: Typography {
        .init(
            display: TypographyGroup(
                medium: .create(name: medium, size: 37, lineHeight: 52),
                small: .create(name: medium, size: 31, lineHeight: 44)
            ),
            displaySmall: TypographyGroup(
                medium: .create(name: medium, size: 31, lineHeight: 44),
                small: .create(name: medium, size: 27, lineHeight: 36)
            ),
            headingExtraLarge: TypographyGroup(
                medium: .create(name: medium, size: 31, lineHeight: 44),
                small: .create(name: medium, size: 27, lineHeight: 36)
            ),
            headingLarge: TypographyGroup(
                medium: .create(name: medium, size: 27, lineHeight: 36),
                small: .create(name: medium, size: 24, lineHeight: 32)
            ),
            heading: TypographyGroup(
                medium: .create(name: medium, size: 23, lineHeight: 32),
                small: .create(name: medium, size: 21, lineHeight: 28)
            ),
            headingSmall: TypographyGroup(
                medium: .create(name: medium, size: 20, lineHeight: 28),
                small: .create(name: medium, size: 19, lineHeight: 24)
            ),
            allCapsHeading: .create(
                name: medium,
                size: 17,
                lineHeight: 20,
                allCaps: true
            ),
            body: .create(
                name: regular,
                size: 17,
                lineHeight: 24
            ),
            bodySemiBold: .create(
                name: semibold,
                size: 17,
                lineHeight: 24
            ),
            bodySmall: .create(
                name: regular,
                size: 15,
                lineHeight: 20
            ),
            bodySmallSemiBold: .create(
                name: semibold,
                size: 15,
                lineHeight: 20
            ),
            caption: .create(
                name: regular,
                size: 13,
                lineHeight: 16
            ),
            captionSemiBold: .create(
                name: semibold,
                size: 13,
                lineHeight: 16
            )
        )
    }
}


