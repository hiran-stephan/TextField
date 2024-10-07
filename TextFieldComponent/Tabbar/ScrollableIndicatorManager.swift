//
//  ScrollableIndicatorManager.swift
//  SecondaryTabBar
//
//  Created by Hiran Stephan on 06/10/24.
//

import Foundation
import SwiftUI

/// A utility manager that determines the visibility of scroll indicators based on the content's position within a scrollable view.
///
/// - Parameters:
///   - geo: The `GeometryProxy` instance that provides the frame and size of the content within the scroll view.
///   - canScrollLeft: An `inout` Boolean that determines whether the left scroll indicator should be visible.
///   - canScrollRight: An `inout` Boolean that determines whether the right scroll indicator should be visible.
struct ScrollableIndicatorManager {
    
    func updateScrollIndicatorsWithoutBounce(
        geo: GeometryProxy,
        canScrollLeft: inout Bool,
        canScrollRight: inout Bool
    ) {
        // Calculate the content's offset position and size
        let contentOffsetX = geo.frame(in: .global).minX
        let contentWidth = geo.size.width
        let scrollViewWidth = UIScreen.main.bounds.width

        // Update the scroll indicators based on the content's position
        canScrollLeft = contentOffsetX < 0
        canScrollRight = (contentWidth + contentOffsetX) > scrollViewWidth
    }
}
