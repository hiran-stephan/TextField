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
     @Environment(\.horizontalSizeClass) var horizontalSizeClass

     public var body: some View {
         VStack {
             // Use the LoginGraphicPlaceholder directly within LoginGraphicContainer
             loginGraphicPlaceholder()
         }
         .frame(
             maxWidth: .infinity,      // Ensures the VStack takes up the full available width
             minHeight: minHeight,     // Dynamically sets the minimum height based on the size class
             maxHeight: maxHeight,     // Dynamically sets the maximum height based on the size class
             alignment: .center        // Centers the content within the available space
         )
     }

     // Placeholder view now part of LoginGraphicContainer
     private func loginGraphicPlaceholder() -> some View {
         if horizontalSizeClass == .regular {
             // Horizontal layout for iPad or larger screens
             HStack(alignment: .center, spacing: BankingTheme.dimens.smallMedium) {
                 imageView()
                 textView()
             }
         } else {
             // Vertical layout for iPhone or smaller screens
             VStack(alignment: .center, spacing: BankingTheme.dimens.smallMedium) {
                 imageView()
                 textView()
             }
         }
     }

     // Determines the minimum height based on the horizontal size class
     private var minHeight: CGFloat {
         horizontalSizeClass == .regular ? Constants.MinHeightRegular : Constants.MinHeightCompact
     }

     // Determines the maximum height based on the horizontal size class
     private var maxHeight: CGFloat {
         horizontalSizeClass == .regular ? Constants.MaxHeightRegular : Constants.MaxHeightCompact
     }

     // Image view component
     private func imageView() -> some View {
         ComponentImage(AuthenticationConstants.Images.loginGraphics, resizable: true)
             .scaledToFit()
             .frame(maxWidth: Constants.MaxWidthImage, maxHeight: Constants.MaxHeightImage, alignment: .center)
     }

     // Text view component
     private func textView() -> some View {
         Text(Constants.defaultTitle)
             .font(BankingTheme.typography.headingSmall.smallFont)
             .foregroundColor(BankingTheme.colors.textPrimary)
     }

     public struct Constants {
         static let defaultTitle: String = "Sign on to CIBC NetBanking"
         static let MaxWidthImage: CGFloat = 135 // Maximum width for the image
         static let MaxHeightImage: CGFloat = 67  // Maximum height for the image

         // Adjustable values for min and max heights based on device class
         static let MinHeightRegular: CGFloat = 120 // Regular size class (iPad)
         static let MaxHeightRegular: CGFloat = 120
         static let MinHeightCompact: CGFloat = 130 // Compact size class (iPhone)
         static let MaxHeightCompact: CGFloat = 130
     }
 }

 
 */
