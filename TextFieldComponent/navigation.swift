/// A view model for managing the layout and size of badge indicators.
/// This class calculates how badge indicators are arranged into rows based on their sizes and the container width.
class BadgeIndicatorListViewModel: ObservableObject {
    /// An array of rows containing badge indicators.
    @Published var rows: [[BadgeIndicatorData]] = []
    /// An array of all badge indicators managed by this view model.
    @Published var badges: [BadgeIndicatorData] = []

    /// The spacing between badges in a row.
    private let tagSpacing: CGFloat = 4
    /// The width of the container in which the badges are displayed.
    var containerWidth: CGFloat {
        didSet {
            calculateRows()
        }
    }

    /// Initializes the view model with badges and a container width.
    /// - Parameters:
    ///   - badges: An array of `BadgeIndicatorData` representing the badges to manage.
    ///   - containerWidth: The initial width of the container.
    init(badges: [BadgeIndicatorData], containerWidth: CGFloat) {
        self.badges = badges
        self.containerWidth = containerWidth
        calculateRows()
    }

    /// Updates the sizes of badges based on the provided widths.
    /// - Parameter widths: An array of `CGFloat` values representing the widths of badges.
    func updateBadgeSizes(widths: [CGFloat]) {
        guard !badges.isEmpty, !widths.isEmpty else { return }
        for (index, width) in widths.enumerated() where index < badges.count {
            badges[index].size = width
        }
        calculateRows()
    }

    /// Recalculates the layout of badge rows based on the container width.
    /// This method organizes the badges into rows, ensuring that they fit within the container width.
    func calculateRows() {
        var newRows: [[BadgeIndicatorData]] = []
        var currentRow: [BadgeIndicatorData] = []
        var totalWidth: CGFloat = 0

        for badge in badges {
            totalWidth += badge.size + tagSpacing
            if totalWidth > containerWidth {
                newRows.append(currentRow)
                currentRow = []
                totalWidth = badge.size + tagSpacing
            }
            currentRow.append(badge)
        }

        if !currentRow.isEmpty {
            newRows.append(currentRow)
        }

        self.rows = newRows
    }

    /// Updates the container width and recalculates the rows.
    /// - Parameter newWidth: The new container width to apply.
    func updateContainerWidth(_ newWidth: CGFloat) {
        self.containerWidth = newWidth
    }

    /// Updates the badge sizes and container width, then recalculates the rows.
    /// - Parameters:
    ///   - widths: An array of `CGFloat` values representing the widths of badges.
    ///   - newWidth: The new container width to apply.
    func updateLayout(widths: [CGFloat], newWidth: CGFloat) {
        updateBadgeSizes(widths: widths)
        updateContainerWidth(newWidth)
    }
}
