//
//  PlaceholderView.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 05/09/24.
//

import Foundation
import SwiftUI

struct PlaceholderView: View {
    // Accesses the current horizontal size class of the environment (e.g., Regular for iPad, Compact for iPhone).
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    // Accesses the current vertical size class of the environment
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        VStack(alignment: .center) {
            // Future content goes here, such as text, images, etc.
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        // Sets the frame for the view, adjusting the minimum and maximum heights dynamically based on size class.
        .frame(
            maxWidth: .infinity,         // Expands to the full width of the available space.
            minHeight: minHeight,
            maxHeight: maxHeight,
            alignment: .center           // Centers the content inside the frame.
        )
        .background(BankingTheme.colors.illustrationPink)
        .cornerRadius(BankingTheme.spacing.paddingSmallMedium)
    }
    
    // Determines the horizontal padding based on the device's horizontal size class.
    private var horizontalPadding: CGFloat {
        horizontalSizeClass == .regular ? BankingTheme.spacing.paddingLarge : BankingTheme.spacing.paddingMedium
    }
    
    // Determines the vertical padding based on the device's vertical size class.
    private var verticalPadding: CGFloat {
        verticalSizeClass == .regular ? BankingTheme.spacing.paddingLarge : BankingTheme.spacing.paddingMedium
    }
    
    // Determines the minimum height of the view based on the horizontal size class.
    private var minHeight: CGFloat {
        horizontalSizeClass == .regular ? Constants.MinHeightRegular : Constants.MinHeightCompact
    }
    
    // Determines the maximum height of the view based on the horizontal size class.
    private var maxHeight: CGFloat {
        horizontalSizeClass == .regular ? Constants.MaxHeightRegular : Constants.MaxHeightCompact
    }
}

struct Constants {
    // These values can be adjusted as needed to control the height of the `PlaceholderView`.
    static let MinHeightRegular: CGFloat = 120  // Minimum height for Regular size class (e.g., iPad).
    static let MaxHeightRegular: CGFloat = 120  // Maximum height for Regular size class.
    static let MinHeightCompact: CGFloat = 130  // Minimum height for Compact size class (e.g., iPhone).
    static let MaxHeightCompact: CGFloat = 130  // Maximum height for Compact size class.
}
