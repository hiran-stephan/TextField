Change Log
* SplashViewModel
    * Added pending deep link check and iOS-specific routing.
    * Clears pending navigation item after navigation to prevent duplicate routing.
* ApplicationNavigatorImpl
    * Improved bottom-nav boundary detection and clear-stack logic.
    * Prevents unnecessary stack clearing and reduces tab flicker.
* AppNavigation
    * Added route comparison to skip redundant destination rendering.
    * Prevents unnecessary SwiftUI re-renders when navigation path updates.
* AuthenticationNavigationItems
    * Updated ROUTE_MAIN to support code parameter.
    * Fixed incorrect navigation root during sign-off (now correctly navigates to ROUTE_MAIN).
