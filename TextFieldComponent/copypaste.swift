@Test
    fun `getCategoryPreferenceData returns ordered subcategory list from business logic`() = runTest {
        // Given
        val inputData = mapOf(
            "Transfers" to listOf(ManageAlertsTestUtils.getReminderManageAlertsConfigSubscription()),
            "Security" to listOf(ManageAlertsTestUtils.getServicingManageAlertsConfigSubscription())
        )

        val expectedList = listOf(
            AlertSubCategoryPreference("Security", inputData["Security"]!!),
            AlertSubCategoryPreference("Transfers", inputData["Transfers"]!!)
        )

        // When: Stub business logic to return the sorted list
        every { mockAlertsBusinessLogic.getOrderedCategoryPreferenceData(inputData) } returns expectedList

        // When: Call ViewModel function
        val result = viewModel.getCategoryPreferenceData(inputData)

        // Then: Assert result
        assertEquals(expectedList, result)

        // And: Verify the business logic was called
        verify { mockAlertsBusinessLogic.getOrderedCategoryPreferenceData(inputData) }
    }
