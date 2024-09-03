//
//  Dimens.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 03/09/24.
//

import Foundation
import SwiftUI

public struct Dimens {
    public let micro: CGFloat
    public let microSmall: CGFloat
    public let small: CGFloat
    public let smallMedium: CGFloat
    public let medium: CGFloat
    public let mediumLarge: CGFloat
    public let large: CGFloat
    public let extraLarge: CGFloat
    public let extraExtraLarge: CGFloat
}

extension Theme {
    static let phoneDimens = {
        return Dimens(
            micro: 2,
            microSmall: 4,
            small: 8,
            smallMedium: 12,
            medium: 16,
            mediumLarge: 20,
            large: 24,
            extraLarge: 32,
            extraExtraLarge: 40
        )
    }()

    static let tabletDimens = {
        return Dimens(
            micro: 3,
            microSmall: 6,
            small: 12,
            smallMedium: 18,
            medium: 24,
            mediumLarge: 30,
            large: 36,
            extraLarge: 48,
            extraExtraLarge: 60
        )
    }()
}
