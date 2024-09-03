//
//  Shapes.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 03/09/24.
//

import Foundation
public struct Shapes {
    public let extraSmall: CGFloat
    public let small: CGFloat
    public let medium: CGFloat
    public let large: CGFloat
    public let extraLarge: CGFloat

    public let textFieldRadius: CGFloat
    public let cardRadius: CGFloat
    public let buttonRadius: CGFloat
}

extension Theme {
    static let defaultShapes = {
        return Shapes(
            extraSmall: 4,
            small: 8,
            medium: 12,
            large: 16,
            extraLarge: 20,
            textFieldRadius: 4,
            cardRadius: 16,
            buttonRadius: 8
        )
    }()
}
