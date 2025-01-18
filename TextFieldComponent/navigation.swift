import SwiftUI

struct AlertManager: ViewModifier {
    @Binding var alertModel: AlertModel

    func body(content: Content) -> some View {
        content
            .background(
                AlertControllerWrapper(
                    isPresented: $alertModel.isPresented,
                    title: alertModel.title,
                    message: alertModel.message,
                    imageName: nil, // Optional: Handle image if required
                    actions: alertModel.actions
                )
            )
    }
}

extension View {
    func manageAlert(with alertModel: Binding<AlertModel>) -> some View {
        self.modifier(AlertManager(alertModel: alertModel))
    }
}


struct AccountPreferencesDetailsScreen: View {
    @State private var alertModel = AlertModel()

    var body: some View {
        VStack {
            ListCardContainer(style: BorderlessCardStyle()) {
                VStack(spacing: BankingTheme.spacing.noPadding) {
                    ForEach(accountControlItems, id: \.actionCellId) { actionItem in
                        ListCellItemToggle(
                            backgroundColor: BankingTheme.colors.illustrationGrey,
                            pressedBackgroundColor: BankingTheme.colors.illustrationGrey,
                            listCellItemData: actionItem,
                            showDivider: false,
                            isToggled: Binding(
                                get: { isEditingVisibility },
                                set: { newValue in
                                    viewModel.updateVisibilityEditingStatus(status: newValue)
                                    updateAlertContent(for: newValue, presenter: viewModel.createScreenPresenter())
                                }
                            )
                        )
                    }
                }
            }
        }
        .manageAlert(with: $alertModel) // Attach the alert manager here
    }

    private func updateAlertContent(for newValue: Bool, presenter: AccountPreferencesDetailsScreenPresenter) {
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
}
