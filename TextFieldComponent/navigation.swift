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
