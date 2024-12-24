fun String?.matchPathParam(route: String, pathKey: String): String? {
    if (this == null) return null

    // Escape special regex characters in the route template
    val escapedTemplate = Regex.escape(route)

    // Replace placeholders with appropriate regex patterns
    val regexPattern = escapedTemplate.replace("\\{\\w+\\}".toRegex()) { matchResult ->
        if (matchResult.value == "{$pathKey}") {
            "([^/]+)" // Capture group for the specified variable
        } else {
            matchResult.value // Keep other placeholders as is
        }
    }

    // Compile the regex pattern
    val regex = Regex(regexPattern)

    // Match and return the captured group
    val matchResult = regex.find(this)
    return matchResult?.groupValues?.get(1) // Extract the matched value for the specified variable
}
