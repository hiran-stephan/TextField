fun ConsentsViewModel.createConsentSectionPresenter(
    sectionIndex: Int,
    documentList: List<ConsentData>,
): ConsentSectionPresenter =
    ConsentSectionPresenter(
        sectionIndex = sectionIndex,
        isCheckboxChecked = consentActionState.value.isCheckboxChecked,
        isConsentValidationFailed = consentActionState.value.isConsentValidationFailed,
        consentData = documentList,
        contentFile = consentResourceState.value.contentFile,
        locale = locale,
        messageCatalogue = messageCatalogue,
        sectionTypes = documentList.map { it.consentType }.toSet(),
        allTypesOnPage = consentUiState.value.data?.groupedConsents
            ?.values?.flatten()?.map { it.consentType }?.toSet() ?: emptySet()
    )


class ConsentSectionPresenter(
    private val contentFile: ContentFile?,
    private val locale: Locale,
    private val messageCatalogue: MessageCatalogue,
    private val consentData: List<ConsentData> = emptyList(),
    private val isCheckboxChecked: Boolean = false,
    private val isConsentValidationFailed: Boolean = false,
    private val sectionIndex: Int,
    private val sectionTypes: Set<String> = emptySet(),
    private val allTypesOnPage: Set<String> = emptySet()            // NEW
) {

    // --- helpers to fetch strings from content ---
    private fun displayContent(key: String, forAccessibility: Boolean = false): String =
        contentFile?.findContentValue(key, locale.lang, forAccessibility).orEmpty()

    private fun singleAgreementKey(type: String) =
        "consents_${type}_agreement_title"

    private fun combinedAgreementKey(types: Collection<String>): String {
        val joined = types.filter { it.isNotBlank() }.sorted().joinToString("_")
        return "consents_${joined}_agreement_title"
    }

    // Try a key; returns empty if key isn't found (or equals the key literal)
    private fun resolveKeyOrEmpty(key: String): String {
        val v = displayContent(key)
        return if (v.isNotBlank() && v != key) v else ""
    }

    // Generate all combinations that include 'self' using the page types (size ≥ 2)
    private fun combosWithSelf(self: String, page: Set<String>): Sequence<List<String>> {
        val pool = (page - "").toList().sorted()
        val selfIdx = pool.indexOf(self)
        if (selfIdx == -1) return emptySequence()

        // sizes: largest first (e.g., 3 → 2)
        return (pool.size downTo 2).asSequence().flatMap { size ->
            sequence {
                // simple combinator without external libs
                val idx = IntArray(size) { it }
                fun current(): List<String> = idx.map { pool[it] }
                fun bump(pos: Int): Boolean {
                    if (pos < 0) return false
                    if (idx[pos] < pool.size - (size - pos)) {
                        idx[pos]++
                        for (i in pos + 1 until size) idx[i] = idx[i - 1] + 1
                        return true
                    }
                    return bump(pos - 1)
                }
                // iterate all combos of given size
                if (size <= pool.size) {
                    do {
                        val c = current()
                        if (c.contains(self)) yield(c)
                    } while (bump(size - 1))
                }
            }
        }
    }

    /** AGREEMENT TEXT
     * Priority:
     *  1) If section has multiple types → use combined key for section types.
     *  2) Else (single-type section) → try combined keys that include this type
     *     with other types present on the PAGE (e.g., 13_14), largest first.
     *  3) Fallback to single key for this type.
     */
    private fun getConsentText(consentType: String): String {
        val section = if (sectionTypes.isEmpty()) setOf(consentType) else sectionTypes

        // 1) combined key for the section itself
        if (section.size > 1) {
            resolveKeyOrEmpty(combinedAgreementKey(section))?.let { if (it.isNotBlank()) return it }
        }

        // 2) try page context combos that include this consentType (even if other types are in other sections)
        if (allTypesOnPage.size >= 2) {
            for (combo in combosWithSelf(consentType, allTypesOnPage)) {
                resolveKeyOrEmpty(combinedAgreementKey(combo))?.let { if (it.isNotBlank()) return it }
            }
        }

        // 3) fallback single
        return displayContent(singleAgreementKey(consentType))
    }

    /** CHECKBOX RULE
     *  - Always required: types listed in "consents_checkbox_required_types" (e.g., 13/EDCA).
     *  - Solo required: types listed in "consents_checkbox_required_when_solo_types"
     *    but ONLY when they are the ONLY type on the PAGE (not just the section).
     */
    private fun consentRequired(consentType: String): Boolean {
        val alwaysRequired = contentFile?.findContentValue(
            "consents_checkbox_required_types", locale.lang, false
        )?.split(",")?.map { it.trim() } ?: emptyList()

        val soloRequired = contentFile?.findContentValue(
            "consents_checkbox_required_when_solo_types", locale.lang, false
        )?.split(",")?.map { it.trim() } ?: emptyList()

        // EDCA etc.
        if (consentType in alwaysRequired) return true

        // DBSA solo rule → based on ALL TYPES ON THE PAGE
        if (allTypesOnPage.size == 1 && allTypesOnPage.first() in soloRequired) return true

        return false
    }

    // … keep the rest of your presenter; when you bind:
    // val consentText: String by lazy { getConsentText(consentType) }
    // val isConsentRequired: Boolean = consentRequired(consentType)
}


