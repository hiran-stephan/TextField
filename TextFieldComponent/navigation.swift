@ViewBuilder
private func errorInlineView() -> AnyView {
    let stateErrorPresenter = viewModel.createErrorPresenter(error: model.state?.error)
    return AnyView(
        ErrorInlineListView(
            alertType: AlertType.failure.rawValue,
            alertMessage: stateErrorPresenter.formatErrorForGlobalAlertMessage(),
            alertCode: stateErrorPresenter.formatErrorForGlobalAlertCode()
        )
    )
}


@ViewBuilder
private func errorFullView() -> AnyView {
    let fullPagePresenter = viewModel.createProblemsFullPagePresenter(stateError: model.state?.error, resourceError: nil)
    return AnyView(
        ErrorContentView(
            imageName: ComponentConstants.Images.alertFullPage,
            title: fullPagePresenter.formatFullPageErrorTitle(),
            subtitle: fullPagePresenter.formatErrorForPageCode(),
            message: fullPagePresenter.formatFullPageAlertMessage(),
            errorCode: fullPagePresenter.code,
            actionLabel: fullPagePresenter.formatFullPageErrorCTA()
        )
    )
}
