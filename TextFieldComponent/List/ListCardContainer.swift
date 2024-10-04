//
//  ListCardContainer.swift
//  ListCell
//
//  Created by Hiran Stephan on 04/10/24.
//
import Foundation
import SwiftUI

/// A container view that wraps content inside a customizable card.
struct ListCardContainer<Content: View>: View {
    /// Determines whether the card has a border
    var hasBorder: Bool
    /// Determines whether the card has rounded corners
    var isRoundedShape: Bool
    /// Background color of the card
    var backgroundColor: Color
    /// Determines whether the card has horizontal padding
    var hasHorizontalPadding: Bool = true
    /// The content to be displayed inside the card
    var content: () -> Content

    var body: some View {
        
        let cardStroke = hasBorder ? BankingTheme.spacing.stroke : BankingTheme.spacing.noPadding
        let cardCornerRadius: CGFloat = isRoundedShape ? BankingTheme.shapes.medium : 0
        let cardBorderColor = hasBorder ? BankingTheme.colors.borderDefault : Color.clear

        VStack {
            content()
        }
        .background(
            backgroundColor
        )
        .padding(.vertical, BankingTheme.dimens.medium)
        .padding(.horizontal, hasHorizontalPadding ? BankingTheme.dimens.medium : BankingTheme.spacing.noPadding)
        .clipShape(RoundedRectangle(cornerRadius: cardCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: cardCornerRadius)
                .stroke(cardBorderColor, lineWidth: cardStroke)
        )
        
    }
}

