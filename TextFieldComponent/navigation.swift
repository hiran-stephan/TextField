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
sealed class ConsentsNavigationItems(
    override val path: String
) : NavigationItem() {

    companion object {
        const val DOMAIN = "consents"

        fun parse(url: String): Main {
            val params = url.parseQueryString()
            val redirect = params["redirect"]?.firstOrNull()
            return Main(redirect = redirect)
        }

        fun cast(item: NavigationItem): Main {
            return item as? Main ?: parse(item.deeplink)
        }
    }

    // 1) data class with domain overridden, path = "" so route is "/consents"
    data class Main(
        val redirect: String? = null
    ) : ConsentsNavigationItems(path = "") {

        // 2) Override domain so that route = "/consents"
        override val domain: String get() = DOMAIN

        // 3) Optionally give yourself a deep-link builder
        fun toDeepLink(): String =
            if (!redirect.isNullOrEmpty()) {
                "cibcus://consents?redirect=$redirect"
            } else {
                "cibcus://consents"
            }
    }

    // etc...
}
