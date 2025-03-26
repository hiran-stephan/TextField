protocol DropdownItem: Identifiable, Hashable {
    var displayTitle: String { get }
}

struct Dropdown<Item: DropdownItem, ErrorContent: View>: View {
    private let title: String
    private let items: [Item]
    @Binding private var selectedItem: Item?
    private let tooltip: ToolTipButton?
    @ViewBuilder private let errorContent: () -> ErrorContent

    init(
        title: String,
        items: [Item],
        selectedItem: Binding<Item?>,
        tooltip: ToolTipButton? = nil,
        @ViewBuilder errorContent: @escaping () -> ErrorContent = { EmptyView() }
    ) {
        self.title = title
        self.items = items
        self._selectedItem = selectedItem
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

            Menu {
                ForEach(items) { item in
                    Button(action: {
                        selectedItem = item
                    }) {
                        Text(item.displayTitle)
                    }
                }
            } label: {
                HStack(alignment: .center, spacing: BankingTheme.dimens.smallMedium) {
                    Text(selectedItem?.displayTitle ?? "Please select an item")
                        .typography(BankingTheme.typography.body)
                        .foregroundColor(BankingTheme.colors.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    ComponentImage(BankingTheme.icons.functional.chevronDown)
                }
                .padding(BankingTheme.dimens.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(BankingTheme.colors.onPrimary)
                .cornerRadius(BankingTheme.dimens.smallMedium)
                .overlay(
                    RoundedRectangle(cornerRadius: BankingTheme.dimens.smallMedium)
                        .inset(by: 0.5)
                        .stroke(BankingTheme.colors.textSecondary, lineWidth: BankingTheme.spacing.stroke)
                )
                .accessibilityElement(children: .combine)
                .accessibilityLabel(Text(title))
                .accessibilityHint(Text("Dropdown menu. Double tap to open."))
                .accessibilityValue(Text(selectedItem?.displayTitle ?? ""))
            }

            errorContent()
                .padding(.top, BankingTheme.dimens.small)
        }
    }
}


struct AccountType: DropdownItem {
    let id: UUID = UUID()
    let displayTitle: String
}


@State private var selectedType: AccountType?

let types = [
    AccountType(displayTitle: "Deposit"),
    AccountType(displayTitle: "Loan"),
    AccountType(displayTitle: "Card")
]

Dropdown(
    title: "Account Type",
    items: types,
    selectedItem: $selectedType,
    tooltip: ToolTipButton(
        title: { "Account Type" },
        message: { "Please select the type of account." },
        accessibilityText: { "Tooltip for account type" }
    ),
    errorContent: {
        if selectedType == nil {
            errorAlertView(message: "Please select an item", code: nil)
        }
    }
)
