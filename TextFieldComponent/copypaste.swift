@Test
fun getSectionStepIndicatorText_returns_index_numbers() {
    val allTypes = consentData.map { it.consentType }.toSet()

    val p1 = presenterFor(sectionTypes = emptySet(), allTypesOnPage = allTypes, sectionIndex = 0)
    assertEquals("1", p1.stepIndicatorText)

    val p2 = presenterFor(sectionTypes = emptySet(), allTypesOnPage = allTypes, sectionIndex = 1)
    assertEquals("2", p2.stepIndicatorText)

    // edge case: 3rd (and higher) section falls back to raw number
    val p3 = presenterFor(sectionTypes = emptySet(), allTypesOnPage = allTypes, sectionIndex = 2)
    assertEquals("3", p3.stepIndicatorText)
}


@Test
fun getSectionStepIndicatorAccessibilityText_returns_localized_when_available_else_number() {
    val allTypes = consentData.map { it.consentType }.toSet()

    val p1 = presenterFor(sectionTypes = emptySet(), allTypesOnPage = allTypes, sectionIndex = 0)
    assertEquals("Step 1.", p1.stepIndicatorAccessibilityText)

    val p2 = presenterFor(sectionTypes = emptySet(), allTypesOnPage = allTypes, sectionIndex = 1)
    assertEquals("Step 2.", p2.stepIndicatorAccessibilityText)

    // edge case: no localized key for 3+, expect raw number
    val p3 = presenterFor(sectionTypes = emptySet(), allTypesOnPage = allTypes, sectionIndex = 2)
    assertEquals("3", p3.stepIndicatorAccessibilityText)
}


