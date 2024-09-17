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
 
 // Define a constant for button height
 let fixedButtonHeight: CGFloat = 76

 SafeSpaceTile(maxHeight: fixedButtonHeight) {
     showSheetOne()
 }

 // Define the sheet presentation logic in a separate function
 private func showSheetOne() {
     Task {
         do {
             await coordinator.transitionToSheet(.sheetOne)
         } catch {
             // Handle any error that might occur during the transition
             print("Failed to present sheet: \(error)")
         }
     }
 }
 
 import SwiftUI

 /// A view representing an individual list cell, displaying primary text, optional secondary text,
 /// and optional icons with customizable badges.
 public struct ListCellItemView: View {
     // Data for the specific list cell.
     let listCellItemData: ListCellItemData
     
     /// Minimum height for the cell.
     static let minCellHeight: CGFloat = 76.0
     
     /// Initializes the `ListCellItemView` with its corresponding data.
     /// - Parameter listCellItemData: The data object containing details for this list cell.
     public init(listCellItemData: ListCellItemData) {
         self.listCellItemData = listCellItemData
     }
     
     /// The body of the list cell, displaying its content within a button.
     public var body: some View {
         Button {
             // TODO: button action
         } label: {
             VStack(spacing: BankingTheme.spacing.noPadding) {
                 HStack(alignment: .center, spacing: BankingTheme.dimens.small) {
                     // Leading Image Placeholder
                     ListCellIconView(imageName: "chevron", padding: BankingTheme.dimens.small)
                     
                     // Primary and Secondary Text
                     listCellTextContent(listCellItemData: listCellItemData)
                     
                     Spacer()
                     
                     // Badge or Count Indicator View
                     listCellBadgeIndicatorView(listCellItemData: listCellItemData)

                     // Trailing Image Placeholder
                     ListCellIconView(imageName: "chevron")
                 }
                 .frame(maxWidth: .infinity, alignment: .center)
                 .padding(BankingTheme.dimens.medium)
             }
             .frame(minHeight: ListCellItemView.minCellHeight) // Setting the minimum height here
            .fixedSize(horizontal: false, vertical: true) // Allow cells to expand vertically only if needed

         }
         .buttonStyle(ListCellButtonModifier())
         .ignoresSafeArea()
     }
     
 /// A subview that renders the primary and optional secondary text for the list cell.
     @ViewBuilder
     private func listCellTextContent(listCellItemData: ListCellItemData) -> some View {
         VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
             Text(listCellItemData.textPrimary)
                 .typography(BankingTheme.typography.body)
                 .foregroundColor(BankingTheme.colors.textPrimary)
                 .lineLimit(nil) // Allow primary text to wrap to multiple lines
                 .fixedSize(horizontal: false, vertical: true) // Ensure the text expands vertically as needed
             
             if let textSecondary = listCellItemData.textSecondary {
                 Text(textSecondary)
                     .typography(BankingTheme.typography.bodySmall)
                     .foregroundColor(BankingTheme.colors.textSecondary)
                     .lineLimit(nil) // Allow secondary text to wrap to multiple lines
                     .fixedSize(horizontal: false, vertical: true) // Ensure the text expands vertically as needed
             }
         }
     }
     
     
     /// A subview that renders a badge or count indicator for the list cell, if available.
     @ViewBuilder
     private func listCellBadgeIndicatorView(listCellItemData: ListCellItemData) -> some View {
         if let trailingNumber = listCellItemData.actionCount {
             HStack {
                 Text(trailingNumber)
                     .font(BankingTheme.typography.caption.font)
                     .frame(width: BankingTheme.dimens.mediumLarge, height: BankingTheme.dimens.medium)
                     .foregroundColor(BankingTheme.colors.textPrimary)
                     .background(Color(hex: 0xFFFCCDDF2))
                     .cornerRadius(BankingTheme.dimens.mediumLarge)
             }
         }
     }
 }

 /// A custom button style for the list cell button, adding a divider at the bottom and handling
 /// background color changes when pressed.
 struct ListCellButtonModifier: ButtonStyle {
     func makeBody(configuration: Configuration) -> some View {
         configuration.label
             .frame(maxWidth: .infinity)
             .overlay(
                 Divider()
                     .frame(height: BankingTheme.spacing.stroke)
                     .background(BankingTheme.colors.borderDefault)
                     .padding(.horizontal, BankingTheme.dimens.medium), alignment: .bottom
             )
             .background(configuration.isPressed ? BankingTheme.colors.pressed : BankingTheme.colors.surfaceVariant)
     }
 }

 
 */
