
import SwiftUI

func deviceResponsiveContent<Content: View>(
    content: Content,
    compactWidth: CGFloat? = nil, // Max width for compact (iPhone)
    regularWidth: CGFloat? = 311, // Fixed width for regular (iPad)
    alignment: Alignment = .center,
    topPadding: CGFloat
) -> some View {
    Group {
        if UIDevice.current.userInterfaceIdiom == .pad {
            // iPad: Fixed width
            content
                .frame(width: regularWidth, alignment: alignment)
                .padding(.top, topPadding)
        } else {
            // iPhone: Max width
            content
                .frame(maxWidth: compactWidth ?? .infinity, alignment: alignment)
                .padding(.top, topPadding)
        }
    }
}

func unexpectedErrorAction(
    actionLabel: String,
    callback: @escaping () -> Void
) -> some View {
    VStack(alignment: .center, spacing: BankingTheme.spacing.noPadding) {
        deviceResponsiveContent(
            content: PrimaryButton(
                content: { Text(actionLabel) },
                callback: callback
            ),
            compactWidth: .infinity, // Max width for iPhones
            regularWidth: 311,      // Fixed width for iPads
            alignment: .center,
            topPadding: SectionMarginLg // Your top padding constant
        )
    }
}
