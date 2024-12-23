data class AccountPreferencesDetails(
    val id: String
) : SettingsNavigationItems(path = "account-preferences-details") {
    override val route: String
        get() = "/$domain/$path?id=$id"

    override val deepLink: String
        get() = "/$domain/$path?id=$id"

    companion object {
        // Base route for comparisons
        const val baseRoute = "/$DOMAIN/account-preferences-details"
        
        fun parse(url: String): AccountPreferencesDetails {
            val params = url.parseQueryString()
            return AccountPreferencesDetails(
                id = params["id"]?.firstOrNull() ?: "missing"
            )
        }
    }
}


case let route where route.starts(with: SettingsNavigationItems.AccountPreferencesDetails.baseRoute):
    if let detailsItem = item as? SettingsNavigationItems.AccountPreferencesDetails {
        AccountPreferencesDetailsScene(navigationItem: detailsItem)
            .navigationBarBackButtonHidden()
    } else {
        Text("Invalid Details Route")
    }
