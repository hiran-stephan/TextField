/**
 * Extracts the value of a path parameter from a URL string.
 *
 * @receiver The input string (URL) from which the path parameter value is extracted.
 * @param route The URL template with placeholders, e.g., "/users/{userId}/posts/{postId}".
 * @param pathKey The name of the placeholder to extract, e.g., "userId".
 * @return The extracted value of the specified path parameter, or null if not found.
 */
fun String?.matchPathParam(route: String, pathKey: String): String? {
    // Return null if the receiver string is null
    if (this == null) return null

    // Escape special regex characters in the route template
    val escapedTemplate = try {
        Regex.escape(route)
    } catch (e: Exception) {
        e.printStackTrace()
        return null // Return null if escaping fails
    }

    // Replace the placeholders in the route with appropriate regex patterns
    val regexPattern = try {
        escapedTemplate.replace("\\{\\w+\\}".toRegex()) { matchResult ->
            if (matchResult.value == "{$pathKey}") {
                "([^/]+)" // Capture group for the specified variable
            } else {
                matchResult.value // Keep other placeholders as is
            }
        }
    } catch (e: Exception) {
        e.printStackTrace()
        return null // Return null if regex pattern generation fails
    }

    // Compile the regex pattern
    val regex = try {
        Pattern.compile(regexPattern)
    } catch (e: Exception) {
        e.printStackTrace()
        return null // Return null if regex compilation fails
    }

    // Match the receiver string (URL) against the compiled regex pattern
    val matcher = regex.matcher(this)
    return if (matcher.find()) {
        matcher.group(1) // Extract the matched value for the specified variable
    } else {
        null // Return null if no match is found
    }
}
