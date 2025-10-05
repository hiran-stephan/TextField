private val splashScope = MainScope() // or viewModelScope if you're in a VM
private var pendingDeepLinkJob: Job? = null

private fun navigateToPendingDeepLink() {
    deepLinkHandler.notifySplashScreenCompletion(completion = true)

    if (AppInfo.isIOS()) {
        // 1) Push the boundary first
        navigateTo(AuthenticationNavigationItems.Main())

        // 2) After a short delay, consume and navigate to the pending deep link (if any)
        pendingDeepLinkJob?.cancel()
        pendingDeepLinkJob = splashScope.launch {
            delay(150) // try 100–200ms; keep it small
            deepLinkHandler.consumePendingNavigationItem()?.let { item ->
                navigateTo(item)
            }
        }
    } else {
        // non-iOS → original behavior
        deepLinkHandler.consumePendingNavigationItem()?.let(::navigateTo)
    }
}

// Call when leaving Splash to avoid a late navigation firing:
private fun cancelPendingDeepLinkNavigation() {
    pendingDeepLinkJob?.cancel()
}
