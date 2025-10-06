// In SplashViewModel.kt

private fun navigateToPendingDeepLink() {
    deepLinkHandler.notifySplashScreenCompletion(completion = true)

    // Atomically read+clear, if you can. If you don't have this helper yet,
    // do getPreSignOnNavigationItem()?.also { clearNavigationItem() }.
    val pending: NavigationItem? =
        deepLinkHandler.consumePreSignOnNavigationItem()

    if (AppInfo.isIOS()) {
        val main = AuthenticationNavigationItems.Main()

        val target: NavigationItem = when {
            // If there's no pre-sign-on item -> go to Main
            pending == null -> main

            // If pending is an auth item and is "route-equivalent" to Main,
            // (i.e., SignOn), PREFER the pending item (it carries code/redirectTo/friendlyId)
            pending is AuthenticationNavigationItems && main.matches(pending) -> pending

            // Otherwise (non-auth or unrelated deep link), navigate to it directly
            else -> pending
        }

        navigateTo(target)
        return
    }

    // Non-iOS: keep your existing behavior (or adjust similarly if desired)
    pending?.let(::navigateTo)
}

// DeepLinkHandler
fun consumePreSignOnNavigationItem(): NavigationItem? {
    val item = getPreSignOnNavigationItem()
    if (item != null) clearNavigationItem()
    return item
}
