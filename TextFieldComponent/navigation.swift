// Route prefix for base matching
    val routePrefix: String
        get() = "/$domain/account-preferences"

    // Check if a route matches this details format
    fun matchesRoute(route: String): Boolean {
        return route.startsWith(routePrefix) && route.contains("account-preferences/")
    }
