private lateinit var contentFile: ContentFile
private val locale = Locale(appRegion = "US")
private lateinit var messageCatalogue: MessageCatalogue
private lateinit var consents: List<ConsentData>

@BeforeTest
fun setup() {
    contentFile = contentFileData()            // your existing fixture (see bottom of file)
    messageCatalogue = getMessageCatalogueData() // your existing fixture (see bottom of file)
    consents = getConsents()                   // your existing fixture producing 13/14/etc.
}

/** Build a presenter for a specific section. */
private fun presenterFor(
    sectionTypes: Set<String>,
    allTypesOnPage: Set<String>,
    sectionIndex: Int = 0,
    isCheckboxChecked: Boolean = false,
    isValidationFailed: Boolean = true
): ConsentSectionPresenter {
    // Subset of ConsentData for this section (keep your own logic if different)
    val sectionConsents = consents.filter { it.consentType in sectionTypes }
    return ConsentSectionPresenter(
        contentFile = contentFile,
        locale = locale,
        messageCatalogue = messageCatalogue,
        consentData = sectionConsents,
        isCheckboxChecked = isCheckboxChecked,
        isConsentValidationFailed = isValidationFailed,
        sectionIndex = sectionIndex,
        sectionTypes = sectionTypes,
        allTypesOnPage = allTypesOnPage
    )
}


@Test
fun `step indicator shows 1 for first section`() {
    val p = presenterFor(sectionTypes = setOf("14"), allTypesOnPage = setOf("13","14"), sectionIndex = 0)
    assertEquals("1", p.stepIndicatorText)
    assertEquals("Step 1.", p.stepIndicatorAccessibilityText)
}

@Test
fun `step indicator shows 2 for second section`() {
    val p = presenterFor(sectionTypes = setOf("13"), allTypesOnPage = setOf("13","14"), sectionIndex = 1)
    assertEquals("2", p.stepIndicatorText)
    assertEquals("Step 2.", p.stepIndicatorAccessibilityText)
}




@Test
fun `DBSA section on page with EDCA uses single 14 agreement text (not combined)`() {
    // Section shows only DBSA, but page contains EDCA as well
    val p = presenterFor(sectionTypes = setOf("14"), allTypesOnPage = setOf("13","14"))
    assertEquals(
        contentFile.findContentValue("consents_14_agreement_title", locale.lang).orEmpty(),
        p.consentText
    )
}

@Test
fun `multi-type section 14_19 uses combined agreement text`() {
    val p = presenterFor(sectionTypes = setOf("14","19"), allTypesOnPage = setOf("14","19"))
    assertEquals(
        contentFile.findContentValue("consents_14_19_agreement_title", locale.lang).orEmpty(),
        p.consentText
    )
}



@Test
fun `EDCA requires checkbox regardless of page composition`() {
    val p = presenterFor(sectionTypes = setOf("13"), allTypesOnPage = setOf("13","14"))
    assertTrue(p.isConsentRequired) // 13 (EDCA) is always required by config
}

@Test
fun `DBSA requires checkbox when presented alone`() {
    val p = presenterFor(sectionTypes = setOf("14"), allTypesOnPage = setOf("14"))
    assertTrue(p.isConsentRequired) // 14 in solo-required list
}

@Test
fun `DBSA does not require checkbox when EDCA also on page`() {
    val p = presenterFor(sectionTypes = setOf("14"), allTypesOnPage = setOf("13","14"))
    assertFalse(p.isConsentRequired)
}



@Test
fun `document titles and a11y titles are read from content file`() {
    val p = presenterFor(sectionTypes = setOf("13","14"), allTypesOnPage = setOf("13","14"))

    val dbsa = p.consentDocuments.first { it.documentType == "14" }
    val edca = p.consentDocuments.first { it.documentType == "13" }

    // Visible titles
    assertEquals(
        contentFile.findContentValue("consents_14_document_title", locale.lang).orEmpty(),
        dbsa.documentTitle
    )
    assertEquals(
        contentFile.findContentValue("consents_13_document_title", locale.lang).orEmpty(),
        edca.documentTitle
    )

    // Accessibility titles
    assertEquals(
        contentFile.findContentValue("consents_14_document_title", locale.lang, forAccessibility = true).orEmpty(),
        dbsa.documentAccessibilityTitle
    )
    assertEquals(
        contentFile.findContentValue("consents_13_document_title", locale.lang, forAccessibility = true).orEmpty(),
        edca.documentAccessibilityTitle
    )
}



@Test
fun `checkbox error message appears only when required and unchecked after validation`() {
    val p = presenterFor(
        sectionTypes = setOf("13"),               // EDCA → required
        allTypesOnPage = setOf("13"),
        isCheckboxChecked = false,
        isValidationFailed = true
    )
    assertTrue(p.consentErrorMessage.isNotBlank())
    assertTrue(p.consentErrorCode.isNotBlank())
}


