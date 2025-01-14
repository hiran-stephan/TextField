class ProblemsListPresenter(
    private val error: Throwable?,
    private val messageCatalogue: MessageCatalogue
) {
    // Generate a list of ProblemsPresenter
    fun getPresenters(): List<ProblemsPresenter> {
        val problems = error?.toProblemsData() ?: emptyList() // Map the Throwable to ProblemData
        return problems.map { problem ->
            ProblemsPresenter(listOf(problem), messageCatalogue)
        }
    }
}

fun createProblemsListPresenter(
    error: Throwable?,
    messageCatalogue: MessageCatalogue
): List<ProblemsPresenter> {
    return ProblemsListPresenter(error, messageCatalogue).getPresenters()
}
