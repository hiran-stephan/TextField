//
//  PlaceholderView.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 05/09/24.
//

import Foundation
import SwiftUI

/// A container view that dynamically adjusts its layout and size based on the device's size class.
/// Displays an image and a title, adapting for different screen sizes such as iPads (Regular) and iPhones (Compact).
public struct LoginGraphicContainer: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    let imageName: String
    let title: String

    /// Custom initializer for LoginGraphicContainer, accepting optional imageName and title as parameters.
    /// If no parameters are provided, it defaults to pre-configured values.
    public init(imageName: String? = nil, title: String? = nil) {
        self.imageName = imageName ?? ComponentConstants.Images.loginGraphics
        self.title = title ?? Constants.defaultTitle
    }

    public var body: some View {
        VStack {
            // The LoginGraphicPlaceholder contains the image and title to be displayed
            LoginGraphicPlaceholder(imageName: imageName, title: title)
                .frame(
                    maxWidth: .infinity, // Makes the view take up the maximum width available
                    minHeight: minHeight, // Dynamically sets the minimum height based on size class
                    maxHeight: maxHeight, // Dynamically sets the maximum height based on size class
                    alignment: .center // Centers the content vertically and horizontally
                )
                .background(BankingTheme.colors.illustrationPink) // Applies a background color to the view
                .cornerRadius(BankingTheme.spacing.paddingSmallMedium) // Rounds the corners of the background
        }
    }

    // Determines the minimum height based on the horizontal size class (iPad or iPhone)
    private var minHeight: CGFloat {
        horizontalSizeClass == .regular ? Constants.MinHeightRegular : Constants.MinHeightCompact
    }

    // Determines the maximum height based on the horizontal size class (iPad or iPhone)
    private var maxHeight: CGFloat {
        horizontalSizeClass == .regular ? Constants.MaxHeightRegular : Constants.MaxHeightCompact
    }

    public struct Constants {
        static let defaultTitle: String = "Sign on to CIBC NetBanking" // Default title for the LoginGraphicPlaceholder

        // Adjustable height values for different device classes (iPad vs iPhone)
        static let MinHeightRegular: CGFloat = 120 // Minimum height for Regular size class (iPad)
        static let MaxHeightRegular: CGFloat = 120 // Maximum height for Regular size class
        static let MinHeightCompact: CGFloat = 130 // Minimum height for Compact size class (iPhone)
        static let MaxHeightCompact: CGFloat = 130 // Maximum height for Compact size class
    }
}


/// A placeholder view that displays an image and a title.
/// It adapts its layout to be horizontal on larger devices (e.g., iPads) and vertical on smaller devices (e.g., iPhones).
struct LoginGraphicPlaceholder: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    /// Property for the image name
    let imageName: String
    /// Property for the title
    let title: String

    /// Initializer for the LoginGraphicPlaceholder, which accepts the image name and title.
    /// These values are passed from the parent container.
    init(imageName: String, title: String) {
        self.imageName = imageName
        self.title = title
    }

    /// The body of the view which contains the image and title text, displayed either horizontally or vertically depending on the device.
    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                // Horizontal layout for iPad or larger screens
                HStack(alignment: .center, spacing: BankingTheme.spacing.paddingSmallMedium) {
                    imageView() // Display the image on the left
                    textView()  // Display the title text on the right
                }
                .frame(maxWidth: .infinity, alignment: .center) // Centers the content horizontally within the available space
            } else {
                // Vertical layout for iPhone or smaller screens
                VStack(alignment: .center, spacing: BankingTheme.spacing.paddingSmallMedium) {
                    imageView() // Display the image at the top
                    textView()  // Display the title text below the image
                }
                .frame(maxWidth: .infinity, alignment: .center) // Centers the content vertically within the available space
            }
        }
    }

    // Image view component
    // Displays the image using the given name, with resizable scaling for dynamic adjustment.
    private func imageView() -> some View {
        ComponentImage(imageName, resizable: true)
            .scaledToFit() // Ensures the image maintains its aspect ratio while fitting within the given frame
            .frame(maxWidth: Constants.MaxWidthImage, maxHeight: Constants.MaxHeightImage, alignment: .center) // Sets the image size
    }

    // Text view component
    // Displays the title text, with the font and color defined by the BankingTheme.
    private func textView() -> some View {
        Text(title)
            .font(BankingTheme.typography.headingSmall.small.font) // Sets the font style based on the BankingTheme
            .foregroundColor(BankingTheme.colors.textPrimary) // Sets the text color based on the BankingTheme
    }

    // Constants for image dimensions to ensure a consistent design
    public struct Constants {
        static let MaxWidthImage: CGFloat = 135 // Maximum width for the image
        static let MaxHeightImage: CGFloat = 60  // Maximum height for the image
    }
}
