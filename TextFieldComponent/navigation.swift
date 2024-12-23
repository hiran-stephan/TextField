data object AccountPreferences : SettingsNavigationItems(path = "account-preferences") {
        override val route: String
            get() = "/$domain/$path"

        override val deepLink: String
            get() = "/$domain/$path"

        companion object {
            fun parse(url: String): AccountPreferencesDetails {
                val params = url.parseQueryString()
                return AccountPreferencesDetails(
                    id = params["id"]?.firstOrNull() ?: "missing"
                )
            }
        }
    }

    data class AccountPreferencesDetails(
        val id: String
    ) : SettingsNavigationItems(path = "account-preferences/details") {
        override val route: String
            get() = "/$domain/$path?id=$id"

        override val deepLink: String
            get() = "/$domain/$path?id=$id"
    }
