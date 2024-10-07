//
//  ScrollIndicator.swift
//  SecondaryTabBar
//
//  Created by Hiran Stephan on 06/10/24.
//

import Foundation
import SwiftUI

/// A visual scroll indicator that appears when there is hidden content on either side of the scrollable view.
///
/// The `ScrollIndicator` displays a chevron icon to indicate that the user can scroll left or right to reveal more content.
/// The indicator is aligned based on the `side` parameter and only appears if the `canScroll` flag is `true`.
///
/// - Parameters:
///   - side: Indicates whether the indicator should appear on the left or right side. Uses the `Side` enum.
///   - canScroll: A Boolean that determines whether the indicator should be visible. If `true`, the indicator appears.
struct ScrollIndicator: View {
    
    /// Enum representing which side the scroll indicator should appear on.
    enum Side {
        case left, right
    }

    /// The side where the scroll indicator should be displayed.
    var side: Side

    /// Determines whether the scroll indicator should be shown. If `true`, the indicator is visible.
    var canScroll: Bool
    
    var tabBarStyle: TabBarStyle

    /// The content of the `ScrollIndicator` view.
    var body: some View {
        if canScroll {
            HStack {
                if side == .left {
                    // Left-side scroll indicator with left-side rounded corners
                    VStack(alignment: .center, spacing: BankingTheme.spacing.noPadding) {
                        Image(systemName: "chevron.left")
                            .frame(width: BankingTheme.dimens.large, height: BankingTheme.dimens.large)
                    }
                    .padding(.horizontal, BankingTheme.spacing.noPadding)
                    .padding(.vertical, BankingTheme.dimens.medium)
                    .background(tabBarStyle.backgroundColor)
                    .clipShape(RoundedCornersShape(corners: [.topLeft, .bottomLeft], radius: tabBarStyle.cornerRadius))
                    Spacer()
                } else {
                    // Right-side scroll indicator with right-side rounded corners
                    Spacer()
                    VStack(alignment: .center, spacing: BankingTheme.spacing.noPadding) {
                        Image(systemName: "chevron.right")
                            .frame(width: BankingTheme.dimens.large, height: BankingTheme.dimens.large)
                    }
                    .padding(.horizontal, BankingTheme.spacing.noPadding)
                    .padding(.vertical, BankingTheme.dimens.medium)
                    .background(tabBarStyle.backgroundColor)
                    .clipShape(RoundedCornersShape(corners: [.topRight, .bottomRight], radius: tabBarStyle.cornerRadius))
                }
            }
        }
    }
}
