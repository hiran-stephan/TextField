struct ManageAlertsAlertSettingsScreen: View {
    @State var isToggled: Bool = false

    // Example hardcoded data object
    private let multipleChannelData = ManageAlertMultipleChannelData(
        titleLabel: "Contact method",
        primaryChannelData: ManageAlertChannelData(
            primaryLabel: "My messages",
            secondaryLabel: "",
            inputViewText: "",
            isChecked: true,
            state: .selected
        ),
        secondaryChannelData: ManageAlertChannelData(
            primaryLabel: "Push notification",
            secondaryLabel: "",
            inputViewText: "",
            isChecked: false,
            state: .default
        )
    )

    var body: some View {
        ScrollView {
            contentView
        }
    }

    @ViewBuilder
    private var contentView: some View {
        VStack(alignment: .center, spacing: BankingTheme.dimens.extraLarge) {
            ManageAlertSectionHeadingView(
                label: "Alert turned on",
                secondaryLabel: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                trailingView: .toggle(isOn: $isToggled)
            )
            .onChange(of: isToggled) { newValue in
                isToggled = newValue
            }
            .manageAlertBackgroundCardStyle()
            .padding(BankingTheme.dimens.medium)
            .background(BankingTheme.colors.surfaceVariant)
            .frame(maxWidth: .infinity, alignment: .topLeading)

            // ✅ Pass full data object
            ManageAlertMultipleChannelView(multipleChannelData)
                .padding(.horizontal)
        }
    }
}
