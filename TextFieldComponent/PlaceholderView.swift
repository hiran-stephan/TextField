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
    
    let imageName: String
    let title: String
    
    // Custom initializer for LoginGraphicContainer, accepting imageName and title as parameters
    public init(imageName: String = "NetBankingGraphic", title: String = "Sign on to CIBC NetBanking") {
        self.imageName = imageName
        self.title = title
    }
    
    var body: some View {
        VStack(alignment: .center) {
            // Pass the image name and title to the placeholder view
            LoginGraphicPlaceholder(imageName: imageName, title: title)
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

/// This view is a placeholder that displays an image and a title in a vertical stack.
struct LoginGraphicPlaceholder: View {
    
    /// Property for the image name
    let imageName: String
    /// Property for the title
    let title: String

    init(imageName: String, title: String) {
        self.imageName = imageName
        self.title = title
    }

    var body: some View {
        VStack(alignment: .center) {
            // Image view displaying the graphic passed in via the imageName parameter
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 200, maxHeight: 200) // Adjust the size of the image as needed

            // Text view displaying the title passed in via the title parameter
            Text(title)
                .font(.headline) // Style the text as a headline
                .padding(.top, 10) // Add padding above the text
        }
    }
}
