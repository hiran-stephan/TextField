private suspend fun getConsents(): List<ConsentData> {
    var consents: List<ConsentData> = emptyList()

    repository.getConsents().collect { result ->
        when (result) {
            is NetworkResultState.Loading -> {
                featureRouter.parent.trackBlockingLoading(result.id, isLoading = true)
            }
            is NetworkResultState.Success -> {
                consents = result.data // Handles 200 OK (parsed list) & 204 No Content (empty list)
            }
            is NetworkResultState.Error -> {
                val errorResponse = result.message

                // Handle 204 gracefully
                if (result.exception is BundleException && result.exception.response?.status?.value == 204) {
                    consents = emptyList()
                } else {
                    _loginAction.update {
                        it.copy(
                            showConsentsErrorDialog = true,
                            error = errorResponse
                        )
                    }
                }
            }
        }
    }
    return consents
}
