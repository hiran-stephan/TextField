//
//  PlaceholderView.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 05/09/24.
//

import Foundation
import SwiftUI

public struct LoginGraphicContainer: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    /// Properties for image name and title
    let imageName: String
    let title: String

    /// Custom initializer for LoginGraphicContainer, accepting imageName and title as parameters
    public init(imageName: String? = nil, title: String? = nil) {
        self.imageName = imageName ?? ComponentConstants.Images.loginGraphics
        self.title = title ?? Constants.defaultTitle
    }

    public var body: some View {
        VStack {
            // Pass the image name and title to the placeholder view
            LoginGraphicPlaceholder(imageName: imageName, title: title)
                .padding(containerPadding) // Dynamic padding based on device size
                .frame(
                    maxWidth: .infinity,
                    minHeight: minHeight,
                    maxHeight: maxHeight,
                    alignment: .center
                )
                .background(BankingTheme.colors.illustrationPink)
                .cornerRadius(BankingTheme.spacing.paddingSmallMedium)
        }
    }

    // Dynamic padding based on the device's size class
    private var containerPadding: CGFloat {
        horizontalSizeClass == .regular ? BankingTheme.spacing.paddingLarge : BankingTheme.spacing.paddingMedium
    }

    // Determines the minimum height based on the horizontal size class
    private var minHeight: CGFloat {
        horizontalSizeClass == .regular ? Constants.MinHeightRegular : Constants.MinHeightCompact
    }

    // Determines the maximum height based on the horizontal size class
    private var maxHeight: CGFloat {
        horizontalSizeClass == .regular ? Constants.MaxHeightRegular : Constants.MaxHeightCompact
    }

    public struct Constants {
        static let defaultTitle: String = "Sign on to CIBC NetBanking"
        
        // Adjustable values for min and max heights based on device class
        static let MinHeightRegular: CGFloat = 120 // Regular size class (iPad)
        static let MaxHeightRegular: CGFloat = 120
        static let MinHeightCompact: CGFloat = 130 // Compact size class (iPhone)
        static let MaxHeightCompact: CGFloat = 130
    }
}


struct Constants {
    // These values can be adjusted as needed to control the height of the `PlaceholderView`.
    static let MinHeightRegular: CGFloat = 120  // Minimum height for Regular size class (e.g., iPad).
    static let MaxHeightRegular: CGFloat = 120  // Maximum height for Regular size class.
    static let MinHeightCompact: CGFloat = 130  // Minimum height for Compact size class (e.g., iPhone).
    static let MaxHeightCompact: CGFloat = 130  // Maximum height for Compact size class.
}

struct LoginGraphicPlaceholder: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    /// Property for the image name
    let imageName: String
    /// Property for the title
    let title: String
    
    init(imageName: String, title: String) {
        self.imageName = imageName
        self.title = title
    }
    
    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                // Horizontal layout for iPad or larger screens
                HStack(alignment: .center, spacing: 20) {
                    imageView()
                    textView()
                }
                .padding(.horizontal, BankingTheme.spacing.paddingMedium)
                .frame(maxWidth: .infinity, alignment: .center) // Ensures layout is centered
            } else {
                // Vertical layout for iPhone or smaller screens
                VStack(alignment: .center, spacing: 10) {
                    imageView()
                    textView()
                }
                .padding(.vertical, BankingTheme.spacing.paddingSmall)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding() // General padding for both layouts
        .background(BankingTheme.colors.backgroundSecondary) // Apply background to differentiate sections
        .cornerRadius(BankingTheme.spacing.paddingSmallMedium) // Rounded corners for a polished look
    }
    
    // Image view component
    @ViewBuilder
    private func imageView() -> some View {
        ComponentImage(imageName, resizable: true)
            .scaledToFit()
            .frame(maxWidth: 135, maxHeight: 60, alignment: .center)
    }
    
    // Text view component
    @ViewBuilder
    private func textView() -> some View {
        Text(title)
            .font(BankingTheme.typography.headingSmall.small.font)
            .multilineTextAlignment(horizontalSizeClass == .regular ? .leading : .center)
            .foregroundColor(BankingTheme.colors.textPrimary)
            .frame(maxWidth: .infinity, alignment: horizontalSizeClass == .regular ? .leading : .center)
    }
}
