@State private var alertModel = AlertModel()

private func updateAlertContent(for newValue: Bool, presenter: AccountPreferencesDetailsScreenPresenter) {
    let title = presenter.accountDisplayDialogTitleText
    let message = presenter.accountDisplayDialogBodyText
    let actions = [
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

    // Recreate the AlertModel to notify SwiftUI
    alertModel = AlertModel(
        isPresented: true,
        title: title,
        message: message,
        actions: actions
    )
}
