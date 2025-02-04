struct TooltipAlertModifier: ViewModifier {
    let showTooltipAlert: Binding<Bool>?
    let infoIconDialogBodyText: String?
    let infoIconDialogCancelButtonText: String?

    func body(content: Content) -> some View {
        if let showTooltipAlert = showTooltipAlert {
            content
                .presentAlert(
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
            content  // If there's no alert, return content as-is
        }
    }
}

public var body: some View {
    VStack(alignment: .leading, spacing: BankingTheme.spacing.noPadding) {
        SectionHeadingView(
            headerText,
            imageName: (infoIconDialogBodyText != nil) ?
                BankingTheme.icons.functional.infoGrey.rawValue : nil,
            imageAccessibilityText: infoIconAccessibilityText,
            trailingContent: {
                trailingContent()
            }
        ) {
            if let showTooltipAlert = showTooltipAlert {
                showTooltipAlert.wrappedValue = true
            }
        }
        
        content
    }
    .modifier(TooltipAlertModifier(
        showTooltipAlert: showTooltipAlert,
        infoIconDialogBodyText: infoIconDialogBodyText,
        infoIconDialogCancelButtonText: infoIconDialogCancelButtonText
    ))
}

