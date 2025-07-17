@Test
fun `getOrderedCategoryPreferenceData returns subcategories in defined order`() {
    val fakeAlert = ManageAlertsConfigSubscription(
        name = "Test Alert"
        // other required fields if any
    )

    val inputMap = mapOf(
        "Transfers" to listOf(fakeAlert),
        "Security" to listOf(fakeAlert),
        "BillPayments" to listOf(fakeAlert),
        "AccountBalance" to listOf(fakeAlert)
    )

    val result = businessLogic.getOrderedCategoryPreferenceData(inputMap)

    val expectedOrder = listOf("Security", "Transfers", "BillPayments", "AccountBalance")
    val resultKeys = result?.map { it.subCategoryId }

    assertEquals(expectedOrder, resultKeys)

    expectedOrder.forEach { id ->
        assertEquals(listOf(fakeAlert), result?.first { it.subCategoryId == id }?.alerts)
    }
}
