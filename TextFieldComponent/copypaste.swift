// AFTER — use a real two-way Binding
.presentAlert(
    isPresented: Binding(
        get: { model.state?.isCancelClicked ?? false },
        set: { isShowing in
            // when alert dismisses (swipe/tap outside), make sure VM is reset
            if !isShowing { viewModel.onCancelDialogDismissed() }
        }
    ),
    title: dialogPresenter.title,
    message: dialogPresenter.message,
    actions: [
        AlertAction(title: dialogPresenter.cancelButtonText, style: .cancel) {
            viewModel.onCancelDialogNoButtonClicked()   // will also hide
        },
        AlertAction(title: dialogPresenter.confirmButtonText, style: .default) {
            viewModel.onCancelDialogYesButtonClicked()  // will also hide
        }
    ]
)

fun onCancelButtonClicked() {
    setCancelDialog(visible = true)
}

fun onCancelDialogYesButtonClicked() {
    setCancelDialog(visible = false)
    analyticsHelper.trackChangeUserIdCancelConfirmationAction()
    goBack()
}

fun onCancelDialogNoButtonClicked() {
    setCancelDialog(visible = false)
}

fun onCancelDialogDismissed() {
    setCancelDialog(visible = false)
}

private fun setCancelDialog(visible: Boolean) {
    _changeUserIdUiState.update { it.copy(isCancelClicked = visible) }
}
