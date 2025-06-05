struct ManageAlertChannelData: Identifiable {
    let id = UUID()
    let primaryLabel: String
    let secondaryLabel: String
    let inputViewText: String
    var isChecked: Bool
    var state: CheckboxState
}


struct ManageAlertMultipleChannelData: Identifiable {
    let id = UUID()
    let titleLabel: String
    var channels: [ManageAlertChannelData]
}

struct ManageAlertMultipleChannelView: View {
    let title: String
    @Binding var channels: [ManageAlertChannelData]

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .typography(BankingTheme.typography.body)
                .foregroundColor(BankingTheme.colors.textPrimary)

            ForEach($channels) { $channel in
                ManageAlertChannelView(
                    label: channel.primaryLabel,
                    secondaryLabel: channel.secondaryLabel,
                    isChecked: $channel.isChecked,
                    checkBoxState: $channel.state,
                    inputText: channel.inputViewText,
                    action: {
                        print("\(channel.primaryLabel) tapped")
                    }
                )
            }
        }
    }
}


struct ManageAlertsAlertSettingsScreen: View {
    @State private var channels: [ManageAlertChannelData] = [
        .init(primaryLabel: "My messages", secondaryLabel: "", inputViewText: "", isChecked: true, state: .selected),
        .init(primaryLabel: "Push notification", secondaryLabel: "", inputViewText: "", isChecked: false, state: .default),
        .init(primaryLabel: "Email", secondaryLabel: "abc@aol.com", inputViewText: "", isChecked: false, state: .default),
        .init(primaryLabel: "Text message", secondaryLabel: "123-456-7890", inputViewText: "", isChecked: false, state: .default)
    ]

    var body: some View {
        ScrollView {
            ManageAlertMultipleChannelView(
                title: "Contact method",
                channels: $channels
            )
            .padding()
        }
    }
}
