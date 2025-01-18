.presentAlert(
        isPresented: Binding(
            get: { currentAlert != nil },
            set: { if !$0 { currentAlert = nil } }
        ),
        title: currentAlert == .showAlert ? "Show Alert" : "Hide Alert",
        message: currentAlert == .showAlert ? "This is the Show Alert message." : "This is the Hide Alert message.",
        actions: [
            AlertAction(title: "OK", style: .default, handler: { currentAlert = nil })
        ]
    )


@State private var currentAlert: AlertType?

enum AlertType {
    case showAlert
    case hideAlert
}

currentAlert = .showAlert

// Computed properties for dynamic alert content
private var alertTitle: String {
    switch currentAlert {
    case .showAlert:
        return "Show Alert"
    case .hideAlert:
        return "Hide Alert"
    case .none:
        return ""
    }
}

private var alertMessage: String {
    switch currentAlert {
    case .showAlert:
        return "This is the Show Alert message."
    case .hideAlert:
        return "This is the Hide Alert message."
    case .none:
        return ""
    }
}

private var alertActions: [AlertAction] {
    switch currentAlert {
    case .showAlert:
        return [
            AlertAction(title: "OK", style: .default, handler: { currentAlert = nil })
        ]
    case .hideAlert:
        return [
            AlertAction(title: "Dismiss", style: .default, handler: { currentAlert = nil })
        ]
    case .none:
        return []
    }
}
