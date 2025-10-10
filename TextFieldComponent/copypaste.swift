// AFTER — real Binding + explicit reset on dismiss
.presentAlert(
    isPresented: Binding(
        get: { model.state?.shouldShowCancelDialog ?? false },
        set: { showing in
            if !showing { viewModel.updateShouldShowCancelDialogState(shouldShowCancelDialog = false) }
        }
    ),
    title: cancelDialogPresenter.title,
    message: cancelDialogPresenter.message,
    actions: [
        AlertAction(title: cancelDialogPresenter.cancelButtonText, style: .cancel) {
            viewModel.onCancelDialogNoButtonClicked()      // also hides
        },
        AlertAction(title: cancelDialogPresenter.confirmButtonText, style: .default) {
            viewModel.onCancelDialogYesButtonClicked()     // also hides + goBack()
        }
    ]
)
