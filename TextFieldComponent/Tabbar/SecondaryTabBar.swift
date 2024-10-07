//
//  SecondaryTabBar.swift
//  SecondaryTabBar
//
//  Created by Hiran Stephan on 06/10/24.
//

import Foundation
import SwiftUI

/// The `SecondaryTabBar` view allows users to switch between tabs in either a scrollable or fixed-width configuration.
public struct SecondaryTabBar: View {

    var tabs: [String]
    @Binding private var selectedTabIndex: Int
    var isScrollable: Bool
    var hasBorder: Bool
    var isRoundedShape: Bool
    var onTabSelected: (Int) -> Void

    /// Initializes a `SecondaryTabBar`.
    ///
    /// - Parameters:
    ///   - tabs: The titles of the tabs to be displayed.
    ///   - selectedTabIndex: A binding to the index of the currently selected tab.
    ///   - isScrollable: A flag indicating if the tab bar should be scrollable.
    ///   - hasBorder: A flag indicating if the tab bar should have a border.
    ///   - isRoundedShape: A flag indicating if the tab bar should have rounded corners.
    ///   - onTabSelected: A closure that is triggered when a tab is selected.
    public init(
        tabs: [String],
        selectedTabIndex: Binding<Int>,
        isScrollable: Bool,
        hasBorder: Bool,
        isRoundedShape: Bool,
        onTabSelected: @escaping (Int) -> Void
    ) {
        self.tabs = tabs
        self._selectedTabIndex = selectedTabIndex
        self.isScrollable = isScrollable
        self.hasBorder = hasBorder
        self.isRoundedShape = isRoundedShape
        self.onTabSelected = onTabSelected
    }

    public var body: some View {
        if isScrollable {
            // Display a scrollable tab bar
            TabBarScrollable(
                tabs: tabs,
                selectedTabIndex: $selectedTabIndex,
                hasBorder: hasBorder,
                isRoundedShape: isRoundedShape,
                isScrollable: isScrollable,
                onTabSelected: onTabSelected
            )
        } else {
            // Display a fixed-width tab bar
            TabBarFixed(
                tabs: tabs,
                selectedTabIndex: $selectedTabIndex,
                hasBorder: hasBorder,
                isRoundedShape: isRoundedShape,
                isScrollable: isScrollable,
                onTabSelected: onTabSelected
            )
        }
    }
}
/*
VStack {
    let tabs1 = ["Tab 1", "Tab 2", "Tab 3", "Tab 4"]
    
    SecondaryTabBar(
        tabs: tabs1,
        selectedTabIndex: $selectedTabIndex,
        isScrollable: true,
        hasBorder: false,
        isRoundedShape: true,
        onTabSelected: { index in
            print("Selected tab: \(index)")
            selectedTabIndex = index
        }
    )
    .padding()
    
    let tabs2 = ["Tab 1 edge case of this", "Tab 2", "Tab 3", "Tab 4"]

    SecondaryTabBar(
        tabs: tabs2,
        selectedTabIndex: $selectedTabIndex,
        isScrollable: true,
        hasBorder: false,
        isRoundedShape: true,
        onTabSelected: { index in
            print("Selected tab: \(index)")
            selectedTabIndex = index
        }
    )
    .padding()
    
    let tabs3 = ["Tab 1", "Tab 2", "Tab 3", "Tab 4"]
    
    SecondaryTabBar(
        tabs: tabs3,
        selectedTabIndex: $selectedTabIndex,
        isScrollable: true,
        hasBorder: true,
        isRoundedShape: true,
        onTabSelected: { index in
            print("Selected tab: \(index)")
            selectedTabIndex = index
        }
    )
    .padding()
    
    let tabs4 = ["Tab 1", "Tab 2", "Tab 3", "Tab 4"]
    
    SecondaryTabBar(
        tabs: tabs4,
        selectedTabIndex: $selectedTabIndex,
        isScrollable: true,
        hasBorder: false,
        isRoundedShape: false,
        onTabSelected: { index in
            print("Selected tab: \(index)")
            selectedTabIndex = index
        }
    )
    .padding()
    
    let tabs5 = ["Tab 1", "Tab 2", "Tab 3", "Tab 4"]
    
    SecondaryTabBar(
        tabs: tabs5,
        selectedTabIndex: $selectedTabIndex,
        isScrollable: true,
        hasBorder: true,
        isRoundedShape: false,
        onTabSelected: { index in
            print("Selected tab: \(index)")
            selectedTabIndex = index
        }
    )
    .padding()
    
    Spacer()

}
.background(Color(.systemGroupedBackground))
*/
