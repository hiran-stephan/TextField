//
//  TabBarScrollable.swift
//  SecondaryTabBar
//
//  Created by Hiran Stephan on 06/10/24.
//

import Foundation
import SwiftUI

/// The `TabBarScrollable` view allows users to scroll horizontally through a list of tabs. It includes visual indicators to
/// show when content can be scrolled left or right.
///
/// - Parameters:
///   - tabs: An array of tab titles to be displayed.
///   - selectedTabIndex: A binding to the index of the currently selected tab.
///   - hasBorder: A Boolean flag that determines if the tab bar has a border.
///   - isRoundedShape: A Boolean flag that determines if the tab bar has rounded corners.
///   - isScrollable: A Boolean flag that determines if the tab bar is scrollable.
///   - onTabSelected: A closure that is called when a tab is selected, passing the index of the selected tab.
struct TabBarScrollable: View {
    
    var tabs: [String]
    @Binding var selectedTabIndex: Int
    var hasBorder: Bool
    var isRoundedShape: Bool
    var isScrollable: Bool
    var onTabSelected: (Int) -> Void

    /// A state variable that tracks whether content can be scrolled to the left.
    @State private var canScrollLeft: Bool = false
    
    /// A state variable that tracks whether content can be scrolled to the right.
    @State private var canScrollRight: Bool = true

    /// Manages the visibility of scroll indicators based on the content's position.
    private let scrollIndicatorManager = ScrollableIndicatorManager()

    var body: some View {
        // Create a tab bar style based on the parameters
        let tabBarStyle = TabBarStyle(hasBorder: hasBorder, isRoundedShape: isRoundedShape)

        ZStack(alignment: .center) {
            VStack(spacing: BankingTheme.spacing.noPadding) {
                ScrollView(.horizontal, showsIndicators: false) {
                    // Layout for tabs
                    TabLayoutView(
                        tabs: tabs,
                        selectedTabIndex: $selectedTabIndex,
                        isScrollable: isScrollable,
                        onTabSelected: onTabSelected
                    )
                    .background(
                        // Track the scroll position to update scroll indicators
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    scrollIndicatorManager.updateScrollIndicatorsWithoutBounce(
                                        geo: geo,
                                        canScrollLeft: &canScrollLeft,
                                        canScrollRight: &canScrollRight
                                    )
                                }
                                .onChange(of: geo.frame(in: .global).minX) { _ in
                                    scrollIndicatorManager.updateScrollIndicatorsWithoutBounce(
                                        geo: geo,
                                        canScrollLeft: &canScrollLeft,
                                        canScrollRight: &canScrollRight
                                    )
                                }
                        }
                    )
                    .padding(.horizontal, BankingTheme.dimens.smallMedium)
                    .padding(.vertical, BankingTheme.spacing.noPadding)
                }
                .background(
                    // Apply the background style with optional corner radius
                    tabBarStyle.backgroundColor
                        .cornerRadius(tabBarStyle.cornerRadius)
                )
                .clipShape(RoundedRectangle(cornerRadius: tabBarStyle.cornerRadius))

                // Optional bottom border if the tab bar has a border and is not rounded
                if isScrollable && hasBorder && !isRoundedShape {
                    Rectangle()
                        .frame(height: tabBarStyle.borderStroke)
                        .foregroundColor(tabBarStyle.borderColor)
                }
            }

            // Left scroll indicator
            if canScrollLeft {
                ScrollIndicator(
                    side: .left,
                    canScroll: canScrollLeft,
                    tabBarStyle: tabBarStyle
                )
            }
            
            // Right scroll indicator
            if canScrollRight {
                ScrollIndicator(
                    side: .right,
                    canScroll: canScrollRight,
                    tabBarStyle: tabBarStyle
                )
            }
        }
    }
}

