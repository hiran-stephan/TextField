//
//  SystemFont.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 03/09/24.
//

import Foundation
import SwiftUI

protocol CustomFont {
    var regular: String { get }
    var medium: String { get }
    var semibold: String { get }
}

extension CustomFont {
    func registerFonts() {
        // No registration needed for system fonts
    }
}

public struct SystemFont: CustomFont {
    var regular = "System-Regular"
    var medium = "System-Medium"
    var semibold = "System-Semibold"

    public init() {
        registerFonts()
    }
}

extension Font {
    static func fixed(_ name: String, size: CGFloat) -> Font {
        switch name {
        case "System-Medium":
            return .system(size: size, weight: .medium)
        case "System-Semibold":
            return .system(size: size, weight: .semibold)
        default:
            return .system(size: size, weight: .regular)
        }
    }

//    static func relative(_ name: String, size: CGFloat, relativeTo textStyle: Font.TextStyle) -> Font {
//        switch name {
//        case "System-Medium":
//            return .system(size: size, weight: .medium, design: .default)
//                .relative(to: textStyle)
//        case "System-Semibold":
//            return .system(size: size, weight: .semibold, design: .default)
//                .relative(to: textStyle)
//        default:
//            return .system(size: size, weight: .regular, design: .default)
//                .relative(to: textStyle)
//        }
//    }
}

// The font registration code is no longer needed since system fonts do not require registration.
