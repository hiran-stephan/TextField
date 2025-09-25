private const val PRIMARY_BUCKET = "1"
private const val OTHERS_BUCKET  = "2"

fun List<ConsentData>.groupBySection(
    contentFile: ContentFile?,
    locale: Locale
): Map<String, List<ConsentData>> {
    if (isEmpty()) return emptyMap()

    // 1) Read ordering from content (CSV string like "13,14,19")
    val order: List<String> = contentFile?.findStringList("consents_order", locale) ?: emptyList()

    // 2) Sort by order index; unknown types go to the end (stable)
    val sorted = if (order.isNotEmpty()) {
        this.sortedWith(
            compareBy<ConsentData> { c ->
                val idx = order.indexOf(c.consentType)
                if (idx >= 0) idx else Int.MAX_VALUE
            }.thenBy { it.consentType } // stable tie-breaker
        )
    } else {
        this // fallback: API order
    }

    // 3) Same 2-bucket shape your UI expects
    val primary = sorted.first()
    val (primaryList, others) = sorted.partition { it == primary }

    return if (others.isNotEmpty())
        mapOf(PRIMARY_BUCKET to primaryList, OTHERS_BUCKET to others)
    else
        mapOf(PRIMARY_BUCKET to primaryList)
}


onStateResult(result) { consentsData ->
    val content = consentResourceState.value.contentFile
    val orderedAndBucketed = consentsData
        .map { it.updateIfAccepted(consentActionState.value.acceptedConsents) }
        .groupBySection(contentFile = content, locale = locale)

    copy(data = ConsentsData(orderedAndBucketed))
}

{
  "consents_order": "13,14,19"
}
