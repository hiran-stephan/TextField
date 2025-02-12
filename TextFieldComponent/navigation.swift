sealed class ConsentsNavigationItems(val path: String) {

    data class Main(
        val redirect: String? = null // Holds the redirect destination
    ) : ConsentsNavigationItems(path = "consents") {

        // Function to generate deep link
        fun toDeepLink(): String {
            return if (!redirect.isNullOrEmpty()) {
                "cibcus://consents?redirect=$redirect"
            } else {
                "cibcus://consents"
            }
        }
    }
}

fun parse(url: String): ConsentsNavigationItems.Main {
    val params = url.parseQueryString()
    val redirect = params["redirect"]?.firstOrNull()

    return ConsentsNavigationItems.Main(redirect = redirect)
}


fun navigateToConsents(rememberMeClicked: Boolean) {
    val navigationItem = if (rememberMeClicked) {
        ConsentsNavigationItems.Main(redirect = "settings/customize")
    } else {
        ConsentsNavigationItems.Main()
    }

    router.navigateTo(navigationItem)
}

class ConsentsPageRouter(...) {

    fun navigateTo(item: ConsentsNavigationItems.Main) {
        val deepLink = item.toDeepLink()
        parent.navigateTo(DeeplinkNavigationItem(Url(deepLink)))
    }
}
