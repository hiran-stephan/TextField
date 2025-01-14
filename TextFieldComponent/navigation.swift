class ProblemsListPresenter(
    private val problems: List<ProblemData>,
    private val messageCatalogue: MessageCatalogue
) {
    fun getPresenters(): List<ProblemsPresenter> {
        return problems.map { problem ->
            ProblemsPresenter(listOf(problem), messageCatalogue)
        }
    }
}

fun createProblemsListPresenter(
    error: Throwable?,
    messageCatalogue: MessageCatalogue
): List<ProblemsPresenter> {
    return ProblemsListPresenter(error?.toProblemsData() ?: emptyList(), messageCatalogue).getPresenters()
}


@ViewBuilder
private func errorInlineView() -> some View {
    // Create the error presenters
    let errorPresenters = viewModel.createProblemsListPresenter()

    VStack(spacing: BankingTheme.spacing.noPadding) {
        ForEach(errorPresenters.indices, id: \.self) { index in
            let presenter = errorPresenters[index]
            errorInlineListView(
                alertType: AlertType.failure.rawValue,
                alertMessage: presenter.formatGlobalAlertMessage(),
                alertCode: presenter.formatErrorForGlobalAlertCode(),
                applyPadding: true
            )
        }
    }
}
