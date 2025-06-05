struct ManageAlertsAlertSettingsScreen: View {
    @State var isToggled: Bool = false

    // Add required states for bindings
    @State private var isCheckedPrimary = true
    @State private var isCheckedSecondary = false
    @State private var statePrimary: CheckboxState = .selected
    @State private var stateSecondary: CheckboxState = .default

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

            // ✅ Insert ManageAlertMultipleChannelView here
            ManageAlertMultipleChannelView(
                title: "Contact method",
                primaryChannel: "My messages",
                isCheckedPrimary: $isCheckedPrimary,
                statePrimary: $statePrimary,
                secondaryChannel: "Push notification",
                isCheckedSecondary: $isCheckedSecondary,
                stateSecondary: $stateSecondary,
                primaryAction: {
                    print("Primary tapped")
                },
                secondaryAction: {
                    print("Secondary tapped")
                }
            )
            .padding(.horizontal)
        }
    }
}
