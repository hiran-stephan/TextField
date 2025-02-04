private var tooltipAlertModifier: some ViewModifier {
    Group {
        if let showTooltipAlert = showTooltipAlert {
            PresentAlertModifier(
                isPresented: showTooltipAlert,
                title: "",
                message: infoIconDialogBodyText ?? "",
                actions: [
                    AlertAction(
                        title: infoIconDialogCancelButtonText ?? "",
                        style: .default,
                        handler: { showTooltipAlert.wrappedValue = false }
                    )
                ]
            )
        } else {
            EmptyModifier()
        }
    }
}

.modifier(tooltipAlertModifier)
