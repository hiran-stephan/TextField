//
//  Theme.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 03/09/24.
//

import Foundation

public enum ThemeMode {
    case light, dark

    public var rawValue: String {
        switch self {
        case .light: return "light"
        case .dark: return "dark"
        }
    }
}

public class Theme: ObservableObject {
    public let mode: ThemeMode
    public let colors: Colours
    public let shapes: Shapes
    public let dimens: Dimens
    public let typography: Typography
    public let spacing: Spacing

    init(mode: ThemeMode, colors: Colours, shapes: Shapes, dimens: Dimens, typography: Typography, spacing: Spacing) {
        self.mode = mode
        self.colors = colors
        self.shapes = shapes
        self.dimens = dimens
        self.typography = typography
        self.spacing = spacing
    }
}

public struct BankingTheme {
    public static var current: Theme = .USLight
    public static var colors: Colours {
        get {
            BankingTheme.current.colors
        }
    }

    public static var shapes: Shapes {
        get {
            BankingTheme.current.shapes
        }
    }

    public static var dimens: Dimens {
        get {
            BankingTheme.current.dimens
        }
    }

    public static var typography: Typography {
        get {
            BankingTheme.current.typography
        }
    }

    public static var spacing: Spacing {
        get {
            BankingTheme.current.spacing
        }
    }
}

public class ThemeManager: ObservableObject {
    @Published public var current: Theme = .USLight {
        didSet {
            BankingTheme.current = current
        }
    }

    public init() { }
}
