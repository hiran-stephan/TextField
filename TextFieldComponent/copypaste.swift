{
  "consents_checkbox_required_types": ["14"],              // EDCA
  "consents_checkbox_required_when_solo_types": ["13"]     // DBSA
}

private fun checkboxRequired(consentTypesOnPage: Set<String>): Boolean {
    // Configurable "always require" list (e.g., EDCA = 14)
    val alwaysRequired = contentFile.findContentArray("consents_checkbox_required_types")
        ?.map { it.toString() }
        ?: emptyList()

    // Configurable "require only when solo" list (e.g., DBSA = 13)
    val soloRequired = contentFile.findContentArray("consents_checkbox_required_when_solo_types")
        ?.map { it.toString() }
        ?: emptyList()

    // Rule 1: if any consent type is in alwaysRequired → require checkbox
    if (consentTypesOnPage.any { it in alwaysRequired }) {
        return true
    }

    // Rule 2: if exactly one consent type and it’s in soloRequired → require checkbox
    if (consentTypesOnPage.size == 1 && consentTypesOnPage.first() in soloRequired) {
        return true
    }

    // Otherwise → no checkbox required
    return false
}


