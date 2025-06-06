@ViewBuilder
private func createChannelView(channel: ManageAlertChannelData, action: (() -> Void)? = nil) -> some View {
    ManageAlertChannelView(
        label: channel.primaryLabel,
        secondaryLabel: channel.secondaryLabel,
        leadingView: {
            CheckboxView(
                isChecked: Binding.constant(channel.isChecked ?? false),
                state: Binding.constant(channel.state ?? .default)
            )
        },
        action: action
    )
}

leadingView: {
    if let isChecked = channel.isChecked, let state = channel.state {
        CheckboxView(
            isChecked: Binding.constant(isChecked),
            state: Binding.constant(state)
        )
    } else {
        EmptyView()
    }
}


