//
//  TabLayoutView.swift
//  SecondaryTabBar
//
//  Created by Hiran Stephan on 06/10/24.
//

import Foundation
import SwiftUI

/// The `TabLayoutView` is responsible for displaying a series of tabs horizontally. It supports both scrollable and non-scrollable configurations.
///
/// - Parameters:
///   - tabs: An array of tab titles to be displayed.
///   - selectedTabIndex: A binding to the index of the currently selected tab. Updates the selected tab's visual state.
///   - isScrollable: A Boolean flag that determines whether the tab layout is scrollable or fixed.
///   - onTabSelected: A closure that is triggered when a tab is selected. Passes the index of the selected tab.
struct TabLayoutView: View {
    
    var tabs: [String]
    @Binding var selectedTabIndex: Int
    var isScrollable: Bool
    var onTabSelected: (Int) -> Void

    var body: some View {
        HStack(alignment: .center, spacing: BankingTheme.spacing.noPadding) {
            ForEach(tabs.indices, id: \.self) { index in
                TabView(
                    title: tabs[index],
                    index: index,
                    selectedTabIndex: $selectedTabIndex,
                    isScrollable: isScrollable
                ) { selectedIndex in
                    onTabSelected(selectedIndex)
                    selectedTabIndex = selectedIndex
                }
            }
        }
    }
}

