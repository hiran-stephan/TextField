data object AccountPreferences : SettingsNavigationItems(
    path = "account-preferences"
) {
    override val route: String
        get() = "/$domain/$path"

    override val deepLink: String
        get() = "/$domain/$path"
}



data class AccountPreferencesDetails(
    val id: String
) : SettingsNavigationItems(path = "account-preferences/{id}") {
    override val route: String
        get() = "/$domain/$path".replace("{id}", id)

    override val deepLink: String
        get() = "/$domain/$path".replace("{id}", id)

    companion object {
        fun parse(url: String): AccountPreferencesDetails {
            val params = url.parseQueryString()
            return AccountPreferencesDetails(
                id = params["id"]?.firstOrNull() ?: "missing"
            )
        }
    }
}
