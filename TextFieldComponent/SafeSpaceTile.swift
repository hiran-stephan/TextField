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
    
    /// Action to be performed when the button is tapped.
    var action: () -> Void
    
    /// The maximum height of the button. Default is `Constants.maxHeight`.
    var maxHeight: CGFloat
    
    /// Initializes the help button view.
    /// - Parameters:
    ///   - action: The action to be triggered when the button is tapped.
    ///   - maxHeight: The height of the button. Defaults to `Constants.maxHeight`.
    init(action: @escaping () -> Void, maxHeight: CGFloat = Constants.maxHeight) {
        self.action = action
        self.maxHeight = maxHeight
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
    
    /// Defines the path for the rounded corners.
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

/// Constants used for configuration.
struct Constants {
    
    static let textNeedMoreHelp: String = "Need more help?"
    static let maxHeight: CGFloat = 68
    
    struct Images {
        static let chevron = "chevron-up"
    }
}


// Usage Examples
/*
 // Basic Usage (with default height)
 HelpButtonView(action: {
     print("Help button tapped!")
 })
 
 // Custom Height Usage
 HelpButtonView(action: {
     print("Help button tapped!")
 }, maxHeight: 100)
 
 */

