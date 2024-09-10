//
//  File.swift
//  TextFieldComponent
//
//  Created by Hiran Stephan on 09/09/24.
//

import Foundation

/* #!/bin/sh

if [ "$YES" = "$OVERRIDE_KOTLIN_BUILD_IDE_SUPPORTED" ]; then
    echo "Skipping Gradle build task invocation due to OVERRIDE_KOTLIN_BUILD_IDE_SUPPORTED environment variable set to YES"
    exit 0
fi

cd $SRCROOT/../

# Embed and sign Apple Framework for Xcode (uncomment if needed)
# ./gradlew :umbrella:embedAndSignAppleFrameworkForXcode

# Create Swift package
./gradlew :umbrella:createSwiftPackage
*/

/*
 
 public struct LoginGraphicContainer: View {

     // Optional property for the marketing image
     private var marketingImage: UIImage?

     /// Access the current horizontal size class of the environment (e.g., Regular for iPad, Compact for iPhone)
     @Environment(\.horizontalSizeClass) var horizontalSizeClass

     // Custom initializer to pass the marketing image
     public init(marketingImage: UIImage? = nil) {
         self.marketingImage = marketingImage
     }

     public var body: some View {
         /// Use view builder to decide which view to render
         VStack {
             contentView()
                 .frame(
                     maxWidth: .infinity,
                     minHeight: minHeight,  // The minimum height based on the size class (regular or compact)
                     maxHeight: maxHeight,  // The maximum height based on the size class (regular or compact)
                     alignment: .center
                 )
         }
         .background(BankingTheme.colors.illustrationPink) // Applies a background color to the view
         .cornerRadius(BankingTheme.dimens.smallMedium)
     }

     /// ViewBuilder function to return either the marketing image or the login graphic placeholder
     @ViewBuilder
     private func contentView() -> some View {
         if marketingImage == nil {
             // Placeholder view when marketingImage is nil
             loginGraphicPlaceholder()
         } else {
             // Marketing image is provided, display it using ComponentImage
             ComponentImage(marketingImage!, resizable: true)
                 .scaledToFit()
         }
     }

     // Placeholder view logic
     @ViewBuilder
     private func loginGraphicPlaceholder() -> some View {
         // Check the device's size class to determine layout type
         if horizontalSizeClass == .regular {
             // Horizontal layout for iPad or larger screens
             HStack(alignment: .center, spacing: BankingTheme.dimens.smallMedium) {
                 imageView() // Displays the image
                 textView()  // Displays the title text
             }
         } else {
             // Vertical layout for iPhone or smaller screens
             VStack(alignment: .center, spacing: BankingTheme.dimens.smallMedium) {
                 imageView()
                 textView()
             }
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

     // Image view component
     private func imageView() -> some View {
         ComponentImage(AuthenticationConstants.Images.loginGraphics, resizable: true)
             .scaledToFit() // Ensures the image scales proportionally to fit the frame
             .frame(
                 maxWidth: Constants.MaxWidthImage,
                 maxHeight: Constants.MaxHeightImage,
                 alignment: .center // Centers the image within the frame
             )
     }

     // Text view component for displaying the title
     private func textView() -> some View {
         Text(Constants.defaultTitle) // Displays the default title text
             .font(BankingTheme.typography.headingSmall.small.font) // Sets the font style and size
             .foregroundColor(BankingTheme.colors.textPrimary) // Sets the text color
     }

     // Constants for the layout and dimensions
     public struct Constants {
         /// Default title to be displayed
         static let defaultTitle: String = "Sign on to CIBC NetBanking"

         /// Maximum width and height for the image
         static let MaxWidthImage: CGFloat = 135 // Maximum width for the image
         static let MaxHeightImage: CGFloat = 67  // Maximum height for the image

         /// Adjustable values for min and max heights based on device class (iPad/iPhone)
         static let MinHeightRegular: CGFloat = 120 // Regular size class (iPad)
         static let MaxHeightRegular: CGFloat = 120
         static let MinHeightCompact: CGFloat = 130 // Compact size class (iPhone)
         static let MaxHeightCompact: CGFloat = 130
     }
 }


 
 */
