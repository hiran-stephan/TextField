@Test
fun `getSectionStepIndicatorText returns "1" for first section and "2" for second`() {
    // first section (index 0) -> "1"
    val presenter1 = ConsentSectionPresenter(
        contentFile = contentFile,
        locale = locale,
        messageCatalogue = messageCatalogue,
        consentData = consentData,
        isCheckboxChecked = isCheckboxChecked,
        isConsentValidationFailed = isConsentValidationFailed,
        sectionIndex = 0,
        sectionTypes = emptySet(),
        allTypesOnPage = consentData.map { it.consentType }.toSet()
    )
    assertEquals("1", presenter1.stepIndicatorText)

    // second section (index 1) -> "2"
    val presenter2 = ConsentSectionPresenter(
        contentFile = contentFile,
        locale = locale,
        messageCatalogue = messageCatalogue,
        consentData = consentData,
        isCheckboxChecked = isCheckboxChecked,
        isConsentValidationFailed = isConsentValidationFailed,
        sectionIndex = 1,
        sectionTypes = emptySet(),
        allTypesOnPage = consentData.map { it.consentType }.toSet()
    )
    assertEquals("2", presenter2.stepIndicatorText)
}

@Test
fun `getSectionStepIndicatorAccessibilityText returns 'Step 1 ' for first and 'Step 2 ' for second`() {
    // first section (index 0) -> "Step 1."
    val presenter1 = ConsentSectionPresenter(
        contentFile = contentFile,
        locale = locale,
        messageCatalogue = messageCatalogue,
        consentData = consentData,
        isCheckboxChecked = isCheckboxChecked,
        isConsentValidationFailed = isConsentValidationFailed,
        sectionIndex = 0,
        sectionTypes = emptySet(),
        allTypesOnPage = consentData.map { it.consentType }.toSet()
    )
    assertEquals("Step 1.", presenter1.stepIndicatorAccessibilityText)

    // second section (index 1) -> "Step 2."
    val presenter2 = ConsentSectionPresenter(
        contentFile = contentFile,
        locale = locale,
        messageCatalogue = messageCatalogue,
        consentData = consentData,
        isCheckboxChecked = isCheckboxChecked,
        isConsentValidationFailed = isConsentValidationFailed,
        sectionIndex = 1,
        sectionTypes = emptySet(),
        allTypesOnPage = consentData.map { it.consentType }.toSet()
    )
    assertEquals("Step 2.", presenter2.stepIndicatorAccessibilityText)
}
