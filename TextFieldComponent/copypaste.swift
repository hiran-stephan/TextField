@Test
fun `getOrderedCategoryPreferenceData returns sorted subcategories in expected order`() {
    // Given
    val inputData = mapOf(
        "Transfers" to listOf(ManageAlertsTestUtils.getRemindersConfig()),
        "Security" to listOf(ManageAlertsTestUtils.getServicesConfig()),
        "BillPayments" to listOf(ManageAlertsTestUtils.getRemindersConfig())
    )

    val expected = listOf(
        AlertSubCategoryPreference("Security", inputData["Security"]!!),
        AlertSubCategoryPreference("Transfers", inputData["Transfers"]!!),
        AlertSubCategoryPreference("BillPayments", inputData["BillPayments"]!!)
    )

    // When
    val result = businessLogic.getOrderedCategoryPreferenceData(inputData)

    // Then
    assertEquals(expected, result)
}


@Test
fun `getOrderedCategoryPreferenceData returns only matching keys in order`() {
    val inputData = mapOf(
        "Information" to listOf(ManageAlertsTestUtils.getRemindersConfig()),
        "Security" to listOf(ManageAlertsTestUtils.getServicesConfig())
    )

    val expected = listOf(
        AlertSubCategoryPreference("Security", inputData["Security"]!!),
        AlertSubCategoryPreference("Information", inputData["Information"]!!)
    )

    val result = businessLogic.getOrderedCategoryPreferenceData(inputData)

    assertEquals(expected, result)
}


@Test
fun `getCategoryPreferenceData returns ordered subcategory list from business logic`() {
    // Given
    val inputData = mapOf(
        "Security" to listOf(ManageAlertsTestUtils.getServicesConfig()),
        "Transfers" to listOf(ManageAlertsTestUtils.getRemindersConfig())
    )

    val expectedList = listOf(
        AlertSubCategoryPreference("Security", inputData["Security"]!!),
        AlertSubCategoryPreference("Transfers", inputData["Transfers"]!!)
    )

    whenever(alertsBusinessLogic.getOrderedCategoryPreferenceData(inputData)).thenReturn(expectedList)

    // When
    val result = manageAlertsSubCategoriesViewModel.getCategoryPreferenceData(inputData)

    // Then
    assertEquals(expectedList, result)
}
