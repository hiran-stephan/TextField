val redirect = navigationItem.redirect
if (!redirect.isNullOrEmpty()) {
    router.redirectToDeepLink(redirect)  // Safe access, no need for !!
} else {
    router.navigateToAuthenticated()
}
