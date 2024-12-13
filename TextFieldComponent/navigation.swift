/// A SwiftUI view that displays a list of badge indicators arranged in rows.
/// The layout dynamically adjusts based on the available container width and badge sizes.
struct BadgeIndicatorListView: View {
    // View model for managing badge indicators and their layout
    @StateObject private var viewModel: BadgeIndicatorListViewModel
    
    // Dynamic container width for calculating row layout
    var containerWidth: CGFloat {
        didSet {
            viewModel.updateContainerWidth(containerWidth)
        }
    }
    
    // Vertical spacing between rows
    private let verticalSpacing: CGFloat = BankingTheme.dimens.small
    // Horizontal spacing between badges within a row
    private let horizontalSpacing: CGFloat = BankingTheme.dimens.small
    
    /// Initializes the `BadgeIndicatorListView`.
    /// - Parameters:
    ///   - badges: An array of `BadgeIndicatorData` to display in the view.
    ///   - containerWidth: The width of the container, used for layout calculations.
    init(badges: [BadgeIndicatorData], containerWidth: CGFloat) {
        _viewModel = StateObject(
            wrappedValue: BadgeIndicatorListViewModel(
                badges: badges,
                containerWidth: containerWidth
            )
        )
        self.containerWidth = containerWidth
    }
    
    /// The content and layout of the badge indicator list.
    var body: some View {
        VStack(alignment: .leading, spacing: verticalSpacing) {
            ForEach(viewModel.rows, id: \.self) { row in
                HStack(spacing: horizontalSpacing) {
                    ForEach(row, id: \.id) { data in
                        BadgeIndicator(badgeIndicatorData: data)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onPreferenceChange(BadgeWidthPreferenceKey.self) { widths in
            viewModel.updateBadgeSizes(widths: widths)
        }
    }
}
