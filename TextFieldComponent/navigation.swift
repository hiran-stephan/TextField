fun Map<String, List<String>>.createRedirectDeepLink(key: String): String? {
    if (isNotEmpty()) {
        val deepLink = StringBuilder()
        val redirectToValue = this[key]?.firstOrNull()

        return redirectToValue?.let { redirectTo ->
            val queryString = this.filterNot { it.key == key }.toQueryString()
            deepLink
                .append("cibcus://$redirectTo")
                .append(queryString)
                .toString()
        }
    }
    return null
}

val deepLink1 = myMap.createRedirectDeepLink(KEY_PARAM_REDIRECT_TO)
val deepLink2 = myMap.createRedirectDeepLink(KEY_PARAM_REDIRECT)
