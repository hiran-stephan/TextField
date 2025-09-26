extension SplashState {
    var shouldShowErrorAlert: Bool {
        // Only show error when error exists AND force upgrade dialog is NOT showing
        (error != nil) && !(showForceUIUpdateDialog ?? false)
    }
}

    .alert(isPresented: .constant(model.state?.shouldShowErrorAlert ?? false)) {
        Alert(
            title: Text(""),
            message: Text(errorPresenter.formatAlertMessage()),
            dismissButton: .default(Text(errorPresenter.fromErrorAlertCta()))
        )
    }


