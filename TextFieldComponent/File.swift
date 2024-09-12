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
 
 public struct ListCellItemView: View {
     let listCellItemData: ListCellItemData

     public init(listCellItemData: ListCellItemData) {
         self.listCellItemData = listCellItemData
     }

     public var body: some View {
         Button {
             // TODO: Add button action here if needed
         } label: {
             HStack(alignment: .center, spacing: Constants.Padding3Xs) {
                 // Left Icon (if available)
                 if let leftIcon = listCellItemData.leftIconName {
                     Image(systemName: leftIcon)
                         .frame(width: 24, height: 24)
                         .cornerRadius(Constants.size0)
                 }

                 VStack(alignment: .leading, spacing: 0) {
                     // Primary text
                     Text(listCellItemData.textPrimary)
                         .font(Font.custom("Whitney", size: Constants.FontSizeBody)) // Adjusted font size
                         .foregroundColor(Constants.TextTextPrimary)
                         .frame(maxWidth: .infinity, alignment: .topLeading)

                     // Secondary text (if available)
                     if let textSecondary = listCellItemData.textSecondary {
                         Text(textSecondary)
                             .font(Font.custom("Whitney", size: Constants.FontSizeBody)) // Adjusted font size
                             .foregroundColor(BankingTheme.colors.textSecondary)
                     }
                 }

                 Spacer()

                 // Right Icon (if available), else chevron
                 if let rightIcon = listCellItemData.rightIconName {
                     Image(systemName: rightIcon)
                         .frame(width: 24, height: 24)
                         .cornerRadius(Constants.size0)
                 } else {
                     Image(systemName: "chevron.right")
                         .frame(width: 24, height: 24)
                         .cornerRadius(Constants.size0)
                 }
             }
             .padding(Constants.Padding2Xs)
             .frame(maxWidth: .infinity, alignment: .leading)
             .background(Constants.BrandWhite)
             .cornerRadius(Constants.SectionMarginOlbMediumScreen)
             .padding(.horizontal, Constants.Padding2Xs)
         }
         .padding(.horizontal, Constants.Padding2Xs) // Adjust outer padding as necessary
     }
 }

 // Constants
 struct Constants {
     static let Padding3Xs: CGFloat = 12
     static let BrandWhite: Color = .white
     static let size0: CGFloat = 0
     static let Padding2Xs: CGFloat = 16
     static let SectionMarginOlbMediumScreen: CGFloat = 50
     static let TextTextPrimary: Color = Color(red: 0.22, green: 0.23, blue: 0.24)
     static let FontSizeBody: CGFloat = 17
 }

 
 */
