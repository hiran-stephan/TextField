struct AlertModel {
    var isPresented: Bool = false
    var title: String = ""
    var message: String = ""
    var actions: [AlertAction] = []
}

@State private var alertModel = AlertModel()

var body: some View {
    ListCellItemToggle(
        isToggled: Binding(
            get: { viewModel.isEditingVisibility },
            set: { newValue in
                viewModel.updateVisibilityEditingStatus(status: newValue)
                updateAlertContent(for: newValue, presenter: viewModel.createScreenPresenter())
            }
        )
    )
    .modifier(PresentAlertModifier(alertModel: $alertModel))
}

// Function to update alert content dynamically
private func updateAlertContent(for newValue: Bool, presenter: ScreenPresenter) {
    alertModel = AlertModel(
        isPresented: true,
        title: presenter.accountDisplayDialogTitleText,
        message: presenter.accountDisplayDialogBodyText,
        actions: [
            AlertAction(
                title: presenter.accountControlDisplayBackButtonText,
                style: .default,
                handler: { alertModel.isPresented = false }
            ),
            AlertAction(
                title: presenter.accountControlDisplayContinueButtonText,
                style: .default,
                handler: { alertModel.isPresented = false }
            )
        ]
    )
}

// Reusable ViewModifier for presenting alerts
struct PresentAlertModifier: ViewModifier {
    @Binding var alertModel: AlertModel

    func body(content: Content) -> some View {
        content.alert(
            isPresented: $alertModel.isPresented,
            content: {
                Alert(
                    title: Text(alertModel.title),
                    message: Text(alertModel.message),
                    primaryButton: alertModel.actions[safe: 0]?.toSwiftUIAlertButton() ?? .default(Text("OK")),
                    secondaryButton: alertModel.actions[safe: 1]?.toSwiftUIAlertButton() ?? .cancel()
                )
            }
        )
    }
}

// Helper Extension to Convert AlertAction to SwiftUIAlertButton
extension AlertAction {
    func toSwiftUIAlertButton() -> SwiftUI.Alert.Button {
        switch style {
        case .default:
            return .default(Text(title), action: handler)
        case .cancel:
            return .cancel(Text(title), action: handler)
        case .destructive:
            return .destructive(Text(title), action: handler)
        }
    }
}

// Safe Access for Array
extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
