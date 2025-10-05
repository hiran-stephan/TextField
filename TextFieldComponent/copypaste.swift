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
