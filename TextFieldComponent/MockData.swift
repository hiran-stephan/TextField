@Test
fun `loadCategoryPreferences success updates state`() = runTest {
    val categoryId = "testCategory"
    val expectedData = ManageAlertsTestUtils.getAlertsAccountsPreferenceData(category = categoryId)

    everySuspend {
        repository.fetchAAlertAccountsConfig(categoryId = categoryId, alertId = "")
    } returns flow {
        emit(NetworkResultState.Success(id = "id", data = expectedData))
    }

    verify(VerifyMode.Ordered) {
        selectAccountViewModel.loadAccounts(categoryId = categoryId, alertId = "")
    }

    verifySuspend {
        repository.fetchAAlertAccountsConfig(categoryId = categoryId, alertId = "")
    }

    val actualResult = selectAccountViewModel.manageAlertSelectAccountUiState.value.alertsAccountsPreferenceData
    assertEquals(expectedData, actualResult)
}
