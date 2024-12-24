fun castAccountPreferencesDetails(item: NavigationItem?): AccountPreferencesDetails {
    requireNotNull(item) { "Navigation item cannot be null" }
    return (item as? AccountPreferencesDetails)
        ?: parseAccountPreferencesDetails(item.deeplink)
}
