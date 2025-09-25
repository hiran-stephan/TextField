{
  "consents_checkbox_required_types": "14",
  "consents_checkbox_required_when_solo_types": "13"
}

private fun checkboxRequired(consentTypesOnPage: Set<String>): Boolean {
    // "Always required" types from JSON (e.g., EDCA = 14)
    val alwaysRequired = contentFile.findContentValue(
        "consents_checkbox_required_types", locale.lang, forAccessibility = false
    )?.split(",")?.map { it.trim() } ?: emptyList()

    // "Solo only" types from JSON (e.g., DBSA = 13)
    val soloRequired = contentFile.findContentValue(
        "consents_checkbox_required_when_solo_types", locale.lang, forAccessibility = false
    )?.split(",")?.map { it.trim() } ?: emptyList()

    // Rule 1: if any consent type is in alwaysRequired → checkbox required
    if (consentTypesOnPage.any { it in alwaysRequired }) {
        return true
    }

    // Rule 2: if exactly one consent type and it’s in soloRequired → checkbox required
    if (consentTypesOnPage.size == 1 && consentTypesOnPage.first() in soloRequired) {
        return true
    }

    // Otherwise → no checkbox required
    return false
}

