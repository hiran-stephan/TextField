@MainActor private func pruneAuthHistoryIfNeeded(for item: NavigationItem) {
    // Only run for AuthenticationNavigationItems
    guard item is AuthenticationNavigationItems else { return }
    guard !navigator.path.isEmpty else { return }

    // Remove matching AuthenticationNavigationItems directly from path
    navigator.path.removeAll { past in
        (past is AuthenticationNavigationItems) &&
        past.matches(navigationItem: item)
    }
}

@MainActor func navigateTo(item: NavigationItem, clearStack: Bool) {
    if clearStack {
        let router = RouterLookup.find(item.domain())
        clearStackToBottomNavigation(matchingRouter: router)
    }

    pruneAuthHistoryIfNeeded(for: item)
    navigator.path.append(item)
}
