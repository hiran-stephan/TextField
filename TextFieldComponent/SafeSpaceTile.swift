//
//  HelpButtonView.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 16/09/24.
//

import Foundation
import SwiftUI

/// A view that displays a help button with customizable height.
struct SafeSpaceTile: View {
    
    /// The maximum height of the button. Default is `SafeSpaceTile.defaultMaxHeight`.
    var maxHeight: CGFloat
    
    /// Action to be performed when the button is tapped.
    var action: () -> Void
    
    /// Default maximum height for the button.
    static let defaultMaxHeight: CGFloat = 68
    
    /// Initializes the help button view.
    /// - Parameters:
    ///   - maxHeight: The height of the button. Defaults to `SafeSpaceTile.defaultMaxHeight`.
    ///   - action: The action to be triggered when the button is tapped.
    init(maxHeight: CGFloat = SafeSpaceTile.defaultMaxHeight, action: @escaping () -> Void) {
        self.maxHeight = maxHeight
        self.action = action
    }
    
    var body: some View {
        
        Button(action: {
            action() // Perform the provided action when the button is tapped.
        }) {
            VStack(alignment: .center, spacing: BankingTheme.spacing.noPadding) {
                // Chevron icon above the text.
                ComponentImage(Constants.Images.chevron, resizable: true)
                    .frame(width: BankingTheme.dimens.large, height: BankingTheme.dimens.large)
                
                // Text indicating Need More Help.
                Text(Constants.textNeedMoreHelp)
                    .font(BankingTheme.typography.bodySmall.font)
                    .multilineTextAlignment(.center)
                    .foregroundColor(BankingTheme.colors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .top)
            }
            .padding(.horizontal, BankingTheme.spacing.noPadding)
            .padding(.top, BankingTheme.dimens.small)
            .padding(.bottom, BankingTheme.spacing.noPadding)
            .frame(maxWidth: .infinity, maxHeight: maxHeight, alignment: .top)
            .background(BankingTheme.colors.illustrationGrey)
            .clipShape(RoundedCornersShape(corners: [.topLeft, .topRight], radius: BankingTheme.dimens.smallMedium))
        }
        .buttonStyle(PlainButtonStyle())
        .frame(maxWidth: .infinity)
    }
}

/// A shape that rounds specific corners.
struct RoundedCornersShape: Shape {
    
    var corners: UIRectCorner
    var radius: CGFloat
    
    /// Initializes the shape with specific corners to round and a corner radius.
    /// - Parameters:
    ///   - corners: The corners to round (e.g., [.topLeft, .topRight]).
    ///   - radius: The radius to apply to the corners.
    init(corners: UIRectCorner, radius: CGFloat) {
        self.corners = corners
        self.radius = radius
    }
    
    /// Defines the path for the rounded corners.
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

/// Constants used for configuration.
struct Constants {
    
    static let textNeedMoreHelp: String = "Need more help?"
    struct Images {
        static let chevron = "chevron-up"
    }
}


// Usage Examples
/*
 // Basic Usage (with default height)
 SafeSpaceTile {
     print("Help button tapped!")
 }
 
 // Custom Height Usage
 SafeSpaceTile(maxHeight: 80) {
     print("Button tapped")
 }
 
 */

