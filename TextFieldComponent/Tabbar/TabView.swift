//
//  TabView.swift
//  SecondaryTabBar
//
//  Created by Hiran Stephan on 06/10/24.
//

import Foundation
import SwiftUI

/// A view that represents an individual tab in a tab bar, displaying a title and a red underline when selected.
///
/// - Parameters:
///   - title: The title of the tab to be displayed.
///   - index: The index of the tab, used to identify which tab was selected.
///   - selectedTabIndex: A binding to the currently selected tab index. Updates the visual state of the tab.
///   - isScrollable: A Boolean flag that indicates whether the tab bar is scrollable. When true, the title text is limited to one line.
///   - onTabSelected: A closure that is called when the tab is selected. Passes the index of the selected tab.
struct TabView: View {
    
    var title: String
    var index: Int
    @Binding var selectedTabIndex: Int
    var isScrollable: Bool
    var onTabSelected: (Int) -> Void

    var body: some View {
        VStack(alignment: .center, spacing: BankingTheme.spacing.noPadding) {
            // Button for selecting the tab
            Button(action: {
                onTabSelected(index)
            }) {
                Text(title)
                    .typography(BankingTheme.typography.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(selectedTabIndex == index ? BankingTheme.colors.primary : BankingTheme.colors.textPrimary)
                    .lineLimit(isScrollable ? 1 : nil)  // If scrollable, limit to one line
                    .fixedSize(horizontal: isScrollable, vertical: false) // Prevent text truncation in scrollable mode
            }
            .padding(BankingTheme.dimens.smallMedium)

            // Red underline indicating the selected tab
            Rectangle()
                .fill(selectedTabIndex == index ? BankingTheme.colors.primary : Color.clear)
                .frame(height: BankingTheme.dimens.microSmall)
                .cornerRadius(BankingTheme.dimens.micro)
        }
        .frame(maxWidth: isScrollable ? nil : .infinity, alignment: .center) // Full-width frame for non-scrollable tabs
    }
}
