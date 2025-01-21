import SwiftUI

func emptyStateAction(actionLabel: String, callback: @escaping () -> Void) -> some View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    return Group {
        if horizontalSizeClass == .compact {
            // iPhone Layout: Max width
            PrimaryButton(
                content: {
                    Text(actionLabel)
                },
                callback: callback
            )
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, BankingTheme.dimens.extraLarge)
        } else {
            // iPad Layout: Fixed width
            PrimaryButton(
                content: {
                    Text(actionLabel)
                },
                callback: callback
            )
            .frame(width: 300, alignment: .center) // Fixed width for iPad
            .padding(.top, BankingTheme.dimens.extraLarge)
        }
    }
}
