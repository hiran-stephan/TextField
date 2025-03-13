override suspend fun getConsents(): Flow<NetworkResultState<List<ConsentData>>> =
    safeApiCall { requestId ->
        val response = profileApiService.getConsents(requestId)

        return@safeApiCall when (response.status) {
            200 -> {
                val consents: List<ConsentData> = response.consents.map { consent ->
                    ConsentData(
                        consentName = consent.consentName.orEmpty(),
                        consentVersion = consent.consentVersion.orEmpty(),
                        consentType = consent.consentType.orEmpty(),
                        consentPath = consent.consentPath.orEmpty()
                    )
                }
                NetworkResultState.Success(consents)
            }
            204 -> {
                // No pending consents, return an empty list
                NetworkResultState.Success(emptyList())
            }
            else -> {
                // Handle unexpected status codes
                NetworkResultState.Error("Unexpected response: ${response.status}")
            }
        }
    }
