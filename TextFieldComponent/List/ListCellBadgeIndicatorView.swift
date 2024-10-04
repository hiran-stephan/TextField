//
//  ListCellBadgeIndicatorView.swift
//  ListCell
//
//  Created by Hiran Stephan on 04/10/24.
//

import Foundation
import SwiftUI

/// A view that displays a badge with an action count, styled with custom typography and colors.
struct ListCellBadgeIndicatorView: View {
    /// The action count to be displayed inside the badge.
    let actionCount: String

    var body: some View {
        HStack {
            // Text displaying the action count, styled with typography and background color.
            Text(actionCount)
                .font(BankingTheme.typography.caption.font)
                .frame(width: BankingTheme.dimens.mediumLarge, height: BankingTheme.dimens.medium)
                .foregroundColor(BankingTheme.colors.textPrimary)
                .background(BankingTheme.colors.illustrationBlueShadow)
                .cornerRadius(BankingTheme.dimens.mediumLarge) // Rounded corners for badge shape
        }
    }
}
