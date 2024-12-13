/// A SwiftUI view that represents a small card with a gradient background, styled text, and customizable padding.
public struct MiniCard: View {
    /// Initializes the `MiniCard` view.
    public init() {}

    public var body: some View {
        HStack(alignment: .center, spacing: BankingTheme.spacing.noPadding) {
            // Card text
            Text("DEBIT")
                .typography(BankingTheme.typography.bodySmallSemiBold)
                .multilineTextAlignment(.trailing)
                .foregroundColor(BankingTheme.colors.background)
                .padding(.trailing, Spacing.miniCardTrailing)
                .padding(.top, Spacing.miniCardTop)
                .padding(.bottom, Spacing.miniCardBottom)
                .frame(width: Spacing.miniCardTextWidth, height: Spacing.miniCardTextHeight, alignment: .trailing)
                .background(miniCardGradient)

            // Card background
                .background(BankingTheme.colors.primary)
                .cornerRadius(BankingTheme.dimens.microSmall)
                .overlay(miniCardOverlay)
        }
    }

    /// A view that adds a rounded rectangle overlay to the card.
    private var miniCardOverlay: some View {
        RoundedRectangle(cornerRadius: BankingTheme.dimens.microSmall)
            .inset(by: Spacing.miniCardInset)
            .stroke(BankingTheme.colors.background, lineWidth: BankingTheme.spacing.stroke)
    }

    /// A gradient view used as the card's background.
    private var miniCardGradient: some View {
        LinearGradient(
            stops: [
                Gradient.Stop(color: Colours.miniCardGradientPrimaryColor, location: 0.00),
                Gradient.Stop(color: Colours.miniCardGradientSecondaryColor, location: 1.00)
            ],
            startPoint: UnitPoint(x: 0, y: 1),
            endPoint: UnitPoint(x: 0.5, y: 0)
        )
    }
}

// MARK: - MiniCard Constants

extension MiniCard {
    /// Constants related to spacing and dimensions for the `MiniCard`.
    private struct Spacing {
        static let miniCardTextHeight: CGFloat = 44.0
        static let miniCardTextWidth: CGFloat = 70.0
        static let miniCardInset: CGFloat = 0.5
        static let miniCardTrailing: CGFloat = 5.0
        static let miniCardTop: CGFloat = 3.0
        static let miniCardBottom: CGFloat = 21.0
    }

    /// Constants for colors used in the `MiniCard` gradient.
    private struct Colours {
        static let miniCardGradientPrimaryColor = Color(red: 0.02, green: 0.02, blue: 0.02).opacity(0.3)
        static let miniCardGradientSecondaryColor = Color.black.opacity(0)
    }
}
