//
//  TabBarFixed.swift
//  SecondaryTabBar
//
//  Created by Hiran Stephan on 06/10/24.
//

import Foundation
import SwiftUI

/// The `TabBarFixed` view allows users to switch between multiple tabs in a fixed-width tab bar.
///
/// - Parameters:
///   - tabs: An array of tab titles to be displayed.
///   - selectedTabIndex: A binding to the index of the currently selected tab.
///   - hasBorder: A Boolean flag that determines whether the tab bar should have a border.
///   - isRoundedShape: A Boolean flag that determines whether the tab bar should have rounded corners.
///   - isScrollable: A Boolean flag to toggle between scrollable and fixed tab bar behavior (should be false in this component).
///   - onTabSelected: A closure that is called when a tab is selected, passing the index of the selected tab.
struct TabBarFixed: View {

    var tabs: [String]
    @Binding var selectedTabIndex: Int
    var hasBorder: Bool
    var isRoundedShape: Bool
    var isScrollable: Bool
    var onTabSelected: (Int) -> Void

    var body: some View {
        // Define the style of the tab bar, including border and background settings.
        let tabBarStyle = TabBarStyle(hasBorder: hasBorder, isRoundedShape: isRoundedShape)

        VStack(spacing: BankingTheme.spacing.noPadding) {
            // Layout of the tabs
            TabLayoutView(
                tabs: tabs,
                selectedTabIndex: $selectedTabIndex,
                isScrollable: isScrollable,
                onTabSelected: onTabSelected
            )
            .frame(maxWidth: .infinity)  // Ensure that the tabs take up the full width
            .padding(.horizontal, BankingTheme.dimens.smallMedium)
            .padding(.vertical, BankingTheme.spacing.noPadding)
            .background(
                tabBarStyle.backgroundColor
                    .cornerRadius(tabBarStyle.cornerRadius)  // Apply corner radius if specified
            )

            // Optional bottom border for the tab bar (only applied if no rounded corners and the tab bar has a border)
            if !isScrollable && hasBorder && !isRoundedShape {
                Rectangle()
                    .frame(height: tabBarStyle.borderStroke)
                    .foregroundColor(tabBarStyle.borderColor)
            }
        }
        .overlay(
            // Add a border around the entire tab bar, if specified.
            Group {
                if !(isScrollable == false && hasBorder && isRoundedShape == false) {
                    RoundedRectangle(cornerRadius: tabBarStyle.cornerRadius)
                        .stroke(tabBarStyle.borderColor, lineWidth: tabBarStyle.borderStroke)
                }
            }
        )
    }
}

