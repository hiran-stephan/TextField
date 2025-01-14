private var isLoading: Bool {
    (model.state?.isLoading ?? false) || (actionModel.state?.isLoading ?? false)
}

private var hasFullError: Bool {
    (model.state?.resource?.hasError ?? false) ||
    (model.state?.hasUnexpectedError ?? false) ||
    (actionModel.state?.hasUnexpectedError ?? false)
}

private var hasInlineError: Bool {
    (model.state?.hasError ?? false) || (actionModel.state?.hasError ?? false)
}

private var combinedErrorPresenters: [ProblemsPresenter] {
    let modelErrors = viewModel.createProblemsListPresenter(error: model.state?.error)
    let actionErrors = viewModel.createProblemsListPresenter(error: actionModel.state?.error)
    return modelErrors + actionErrors
}


struct ErrorListView: View {
    let errorPresenters: [ProblemsPresenter]
    let spacing: CGFloat

    var body: some View {
        VStack(spacing: spacing) {
            ForEach(errorPresenters.indices, id: \.self) { index in
                let presenter = errorPresenters[index]
                ErrorInlineView(presenter: presenter)
            }
        }
    }
}

struct ErrorInlineView: View {
    let presenter: ProblemsPresenter

    var body: some View {
        errorInlineListView(
            alertType: presenter.formatGlobalAlertType(),
            alertMessage: presenter.formatGlobalAlertMessage(),
            alertCode: presenter.formatErrorForGlobalAlertCode(),
            applyPadding: true
        )
    }
}

var body: some View {
    ScrollView {
        LoadingErrorLayout(
            isLoading: isLoading,
            hasData: model.state?.hasData ?? false,
            hasFullError: hasFullError,
            hasInlineError: hasInlineError,
            inlineError: {
                ErrorListView(
                    errorPresenters: combinedErrorPresenters,
                    spacing: BankingTheme.dimensions.smallMedium
                )
            },
            fullError: {
                errorFullView()
            }
        ) {
            contentView()
        }
    }
}

