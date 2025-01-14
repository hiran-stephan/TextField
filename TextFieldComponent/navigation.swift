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
