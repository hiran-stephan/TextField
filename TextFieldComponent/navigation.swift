// MARK: - DropdownItem Protocol
protocol DropdownItem: Identifiable, Hashable {
    var displayTitle: String { get }
}

// MARK: - DropdownState Enum
enum DropdownState {
    case `default`
    case focused
    case error
    case focusedError
    case disabled
}

// MARK: - Dropdown View
struct Dropdown<Item: DropdownItem, ErrorContent: View>: View {
    private let title: String
    private let items: [Item]
    @Binding private var selectedItem: Item?
    private let state: DropdownState
    private let tooltip: ToolTipButton?
    @ViewBuilder private let errorContent: () -> ErrorContent

    init(
        title: String,
        items: [Item],
        selectedItem: Binding<Item?>,
        state: DropdownState = .default,
        tooltip: ToolTipButton? = nil,
        @ViewBuilder errorContent: @escaping () -> ErrorContent = { EmptyView() }
    ) {
        self.title = title
        self.items = items
        self._selectedItem = selectedItem
        self.state = state
        self.tooltip = tooltip
        self.errorContent = errorContent
    }

    var body: some View {
        VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
            HStack(spacing: BankingTheme.spacing.noPadding) {
                Text(title)
                    .typography(BankingTheme.typography.body)
                    .foregroundColor(BankingTheme.colors.textPrimary)

                if let tooltip = tooltip {
                    tooltip
                }
            }

            let borderColor = state.borderColor
            let backgroundColor = state.backgroundColor
            let textColor = state.textColor

            Menu {
                ForEach(items) { item in
                    Button(action: {
                        selectedItem = item
                    }) {
                        if selectedItem == item {
                            Label(item.displayTitle, systemImage: "checkmark")
                        } else {
                            Text(item.displayTitle)
                        }
                    }
                }
            } label: {
                HStack(alignment: .center, spacing: BankingTheme.dimens.smallMedium) {
                    Text(selectedItem?.displayTitle ?? "Please select an item")
                        .typography(BankingTheme.typography.body)
                        .foregroundColor(textColor)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    ComponentImage(BankingTheme.icons.functional.chevronDown)
                }
                .padding(BankingTheme.dimens.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(backgroundColor)
                .cornerRadius(BankingTheme.dimens.smallMedium)
                .overlay(
                    RoundedRectangle(cornerRadius: BankingTheme.dimens.smallMedium)
                        .inset(by: 0.5)
                        .stroke(borderColor, lineWidth: BankingTheme.spacing.stroke)
                )
                .accessibilityElement(children: .combine)
                .accessibilityLabel(Text(title))
                .accessibilityHint(Text("Dropdown menu. Double tap to open."))
                .accessibilityValue(Text(selectedItem?.displayTitle ?? ""))
            }
            .disabled(state == .disabled)

            errorContent()
                .padding(.top, BankingTheme.dimens.small)
        }
    }
}

extension DropdownState {
    var borderColor: Color {
        switch self {
        case .default:
            return BankingTheme.colors.textSecondary
        case .focused:
            return BankingTheme.colors.textPrimary
        case .error, .focusedError:
            return BankingTheme.colors.alertError
        case .disabled:
            return BankingTheme.colors.textDisabled
        }
    }

    var backgroundColor: Color {
        switch self {
        case .disabled:
            return BankingTheme.colors.disabledBackground
        default:
            return BankingTheme.colors.onPrimary
        }
    }

    var textColor: Color {
        switch self {
        case .disabled:
            return BankingTheme.colors.textDisabled
        default:
            return BankingTheme.colors.textPrimary
        }
    }
}
