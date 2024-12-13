import SwiftUI

struct ContentView: View {

    @StateObject var viewModel = ContentViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(viewModel.rows, id: \.self) { row in
                HStack(spacing: 6) {
                    ForEach(row) { tag in
                        HStack(spacing: 8) {
                            if let iconName = tag.icon {
                                Image(systemName: iconName) // Use SF Symbols as the icon
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(.blue)
                            }
                            Text(tag.name)
                                .font(.system(size: 16))
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(Color.gray.opacity(0.3)))
                    }
                }
                .frame(height: 28)
                .padding(.bottom, 10)
            }
        }
        .padding(24)
    }
}

struct Tag: Identifiable, Hashable {
    var id = UUID().uuidString
    var name: String
    var icon: String? // Optional icon (SF Symbol name)
    var size: CGFloat = 0
}

class ContentViewModel: ObservableObject {

    @Published var rows: [[Tag]] = []
    @Published var tags: [Tag] = [
        Tag(name: "XCode", icon: "hammer.fill"),
        Tag(name: "iOS", icon: "iphone"),
        Tag(name: "iOS App Development", icon: "app"),
        Tag(name: "Swift", icon: "swift"),
        Tag(name: "SwiftUI", icon: nil),
        Tag(name: "Custom Layouts", icon: "rectangle.grid.1x2.fill")
    ]

    init() {
        calculateRows()
    }

    func calculateRows() {
        var rows: [[Tag]] = []
        var currentRow: [Tag] = []
        var totalWidth: CGFloat = 0

        let screenWidth = UIScreen.screenWidth - 10
        let tagSpacing: CGFloat = 56

        if !tags.isEmpty {
            for index in 0..<tags.count {
                self.tags[index].size = tags[index].name.getSize(withIcon: tags[index].icon != nil)
            }

            tags.forEach { tag in
                totalWidth += (tag.size + tagSpacing)

                if totalWidth > screenWidth {
                    totalWidth = (tag.size + tagSpacing)
                    rows.append(currentRow)
                    currentRow.removeAll()
                    currentRow.append(tag)
                } else {
                    currentRow.append(tag)
                }
            }

            if !currentRow.isEmpty {
                rows.append(currentRow)
                currentRow.removeAll()
            }

            self.rows = rows
        } else {
            self.rows = []
        }
    }
}

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.width
}

extension String {
    func getSize(withIcon hasIcon: Bool = false) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 16)
        let attributes = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: attributes)
        return size.width + (hasIcon ? 24 : 0) // Add space for the icon if present
    }
}






import SwiftUI

// BadgeIndicatorData Model
struct BadgeIndicatorData: Identifiable, Hashable {
    var id = UUID().uuidString
    var type: BadgeIndicatorType
    var labelText: String
    var showLeadingIcon: Bool
    var size: CGFloat

    init(type: BadgeIndicatorType, labelText: String, showLeadingIcon: Bool = false, size: CGFloat = 0) {
        self.type = type
        self.labelText = labelText
        self.showLeadingIcon = showLeadingIcon
        self.size = size
    }
}

// BadgeIndicatorType Enum (example, modify as per your requirements)
enum BadgeIndicatorType {
    case passiveReversed
}

// BadgeIndicatorsView
struct BadgeIndicatorsView: View {
    @StateObject var viewModel = BadgeIndicatorsViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(viewModel.rows, id: \.self) { row in
                HStack(spacing: 6) {
                    ForEach(row, id: \.id) { tag in
                        HStack(spacing: 8) {
                            if tag.showLeadingIcon {
                                Image(systemName: "star.fill") // Replace with your icon logic
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(.blue)
                            }
                            Text(tag.labelText)
                                .font(.system(size: 16))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(Capsule().fill(Color.gray.opacity(0.3)))
                                .frame(height: 28)
                        }
                        .padding(.bottom, 10)
                    }
                }
            }
        }
        .padding(24)
    }
}

// BadgeIndicatorsViewModel
class BadgeIndicatorsViewModel: ObservableObject {
    @Published var rows: [[BadgeIndicatorData]] = []
    @Published var badges: [BadgeIndicatorData] = [
        BadgeIndicatorData(type: .passiveReversed, labelText: "XCode"),
        BadgeIndicatorData(type: .passiveReversed, labelText: "iOS"),
        BadgeIndicatorData(type: .passiveReversed, labelText: "iOS App Development"),
        BadgeIndicatorData(type: .passiveReversed, labelText: "Swift"),
        BadgeIndicatorData(type: .passiveReversed, labelText: "Custom Layouts")
    ]

    init() {
        calculateRows()
    }

    func calculateRows() {
        var rows: [[BadgeIndicatorData]] = []
        var currentRow: [BadgeIndicatorData] = []
        var totalWidth: CGFloat = 0
        let screenWidth = UIScreen.screenWidth - 10
        let tagSpacing: CGFloat = 6

        // Update badge sizes
        for index in badges.indices {
            badges[index].size = badges[index].labelText.getSize(withIcon: badges[index].showLeadingIcon)
        }

        // Arrange badges into rows
        badges.forEach { badge in
            totalWidth += badge.size + tagSpacing

            if totalWidth > screenWidth {
                rows.append(currentRow)
                currentRow.removeAll()
                totalWidth = badge.size + tagSpacing
            }
            currentRow.append(badge)
        }

        if !currentRow.isEmpty {
            rows.append(currentRow)
        }

        self.rows = rows
    }
}

// Extensions for Size Calculation and Screen Width
extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.width
}

extension String {
    func getSize(withIcon hasIcon: Bool = false) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 16)
        let attributes = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: attributes)
        return size.width + (hasIcon ? 24 : 0) // Add space for the icon if present
    }
}



class BadgeIndicatorsViewModel: ObservableObject {
    @Published var rows: [[BadgeIndicatorData]] = []
    @Published var badges: [BadgeIndicatorData]

    init(badges: [BadgeIndicatorData]) {
        self.badges = badges
        calculateRows()
    }

    func calculateRows() {
        var rows: [[BadgeIndicatorData]] = []
        var currentRow: [BadgeIndicatorData] = []
        var totalWidth: CGFloat = 0
        let screenWidth = UIScreen.screenWidth - 10
        let tagSpacing: CGFloat = 6

        // Update badge sizes
        for index in badges.indices {
            badges[index].size = badges[index].labelText.getSize(withIcon: badges[index].showLeadingIcon)
        }

        // Arrange badges into rows
        badges.forEach { badge in
            totalWidth += badge.size + tagSpacing

            if totalWidth > screenWidth {
                rows.append(currentRow)
                currentRow.removeAll()
                totalWidth = badge.size + tagSpacing
            }
            currentRow.append(badge)
        }

        if !currentRow.isEmpty {
            rows.append(currentRow)
        }

        self.rows = rows
    }
}


struct BadgeIndicatorsView: View {
    @StateObject private var viewModel: BadgeIndicatorsViewModel

    init(badges: [BadgeIndicatorData]) {
        _viewModel = StateObject(wrappedValue: BadgeIndicatorsViewModel(badges: badges))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(viewModel.rows, id: \.self) { row in
                HStack(spacing: 6) {
                    ForEach(row, id: \.id) { tag in
                        HStack(spacing: 8) {
                            if tag.showLeadingIcon {
                                Image(systemName: "star.fill") // Replace with your icon logic
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(.blue)
                            }
                            Text(tag.labelText)
                                .font(.system(size: 16))
                                .lineLimit(2) // Allow up to two lines
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(Capsule().fill(Color.gray.opacity(0.3)))
                        }
                        .padding(.bottom, 10)
                    }
                }
            }
        }
        .padding(24)
    }
}


struct BodyTextView: View {
    let primaryText: String
    let secondaryText: String

    var body: some View {
        VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
            // Primary body text
            Text(primaryText)
                .typography(BankingTheme.typography.body)
                .foregroundColor(BankingTheme.colors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .topLeading)

            // Secondary body text
            Text(secondaryText)
                .typography(BankingTheme.typography.bodySmall)
                .foregroundColor(BankingTheme.colors.textSecondary)
                .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .background(
            GeometryReader { geometry in
                Color.clear
                    .preference(
                        key: ViewFramePreferenceKey.self,
                        value: geometry.frame(in: .global)
                    )
            }
        )
    }
}


struct ViewFramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}


struct AccountPreferenceCard: View {
    let data: AccountPreferenceCardData
    @State private var bodyTextWidth: CGFloat = 0

    var body: some View {
        HStack(alignment: .center, spacing: BankingTheme.dimens.smallMedium) {
            VStack(alignment: .leading, spacing: BankingTheme.dimens.smallMedium) {
                // Primary and secondary text
                BodyTextView(
                    primaryText: data.primaryText,
                    secondaryText: data.secondaryText
                )
                .onPreferenceChange(ViewFramePreferenceKey.self) { frame in
                    bodyTextWidth = frame.width
                }

                // Badge indicators
                if !data.badgeIndicators.isEmpty {
                    BadgeIndicatorsView(
                        badges: data.badgeIndicators,
                        containerWidth: bodyTextWidth
                    )
                }

                // Mini card if applicable
                if data.showMiniCard {
                    MiniCard()
                }
            }
            .padding(BankingTheme.dimens.medium)
            .background(BankingTheme.colors.surface)
            .cornerRadius(BankingTheme.dimens.smallMedium)
            .frame(maxWidth: .infinity, alignment: .leading)

            // Chevron icon
            ListCellIconView(imageName: ComponentConstants.Images.chevron)
        }
    }
}
