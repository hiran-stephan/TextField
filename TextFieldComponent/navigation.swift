class AccountPreferencesRepositoryMock : AccountPreferencesRepository {
    override suspend fun loadResources(): Flow<NetworkResultState<ContentResources>> = flow {
        val mockContentResources = ContentResources(
            ContentFile(
                mapOf(
                    ACCOUNT_PREFERENCES to LocalizedText(
                        en = "Account Preferences",
                        accessibility_en = "Account Preferences"
                    )
                )
            )
        )
        emit(NetworkResultState.Success(id = "id", data = mockContentResources))
    }
}


