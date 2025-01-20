fun getAccountsSummary() = launch {
    repository.getAccountsSummary().collect { result ->
        _homeState.value = result.isLoading {
            isLoading -> copy(isLoading = isLoading)
        }.onStateSuccess { response ->
            handleAccountsSummary(response)
        }.onStateException { error ->
            copy(isLoading = false, error = error)
        }
    }
}

private fun handleAccountsSummary(response: HomeAccountsSummary): SummaryUiState {
    return when {
        response.accountGroups.all { it.homeAccounts.isEmpty() } -> {
            val exception = createNoAccountsException()
            copy(
                noAccountsToDisplay = true,
                error = exception
            )
        }
        response.problems != null -> {
            val exception = createProblemsException(response.problems)
            trackErrorState(exception.problems)
            copy(
                accountsSummary = response,
                error = exception
            )
        }
        else -> {
            copy(accountsSummary = response)
        }
    }
}

private fun createNoAccountsException(): ProblemsException {
    val problemData = ProblemApiData(
        code = "001",
        type = "NoAccounts",
        field = "accountGroups"
    ).toProblemData()
    return ProblemsException(listOf(problemData))
}

private fun createProblemsException(problems: List<ProblemApiData>): ProblemsException {
    return ProblemsException(problems.map { it.toProblemData() })
}
