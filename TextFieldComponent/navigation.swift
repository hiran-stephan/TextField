import SwiftUI
import Theme

public struct SectionHeadingView<TrailingContent: View>: View {
    let heading: String
    let imageName: String?
    let imageAccessibilityText: String?
    let action: (() -> Void)?
    @ViewBuilder let trailingContent: () -> TrailingContent

    public init(
        heading: String,
        imageName: String? = nil,
        imageAccessibilityText: String? = nil,
        action: (() -> Void)? = nil,
        @ViewBuilder trailingContent: @escaping () -> TrailingContent = { EmptyView() } // Default is EmptyView
    ) {
        self.heading = heading
        self.imageName = imageName
        self.imageAccessibilityText = imageAccessibilityText
        self.action = action
        self.trailingContent = trailingContent
    }

    public var body: some View {
        HStack(alignment: .center, spacing: BankingTheme.spacing.noPadding) {
            Text(heading.uppercased())
                .typography(BankingTheme.typography.allCapsHeading)
                .foregroundColor(BankingTheme.colors.textPrimary)

            Spacer()

            if let imageName = imageName {
                Button(action: {
                    action?()
                }) {
                    Image(systemName: imageName)
                        .accessibility(label: Text(imageAccessibilityText ?? ""))
                }
            }

            trailingContent()
        }
    }
}
