// ApplicationNavigatorImpl.swift

@MainActor func navigateTo(item: NavigationItem, clearStack: Bool) {
    if clearStack {
        let router = RouterLookup.find(item.domain())
        clearStackToBottomNavigation(matchingRouter: router)
    }

    // NEW: only for Authentication items, remove older equivalent auth entries
    pruneAuthHistoryIfNeeded(for: item)

    navigator.path.append(item)
}

@MainActor private func pruneAuthHistoryIfNeeded(for item: NavigationItem) {
    // Gate: run ONLY when pushing an AuthenticationNavigationItems value
    guard item is AuthenticationNavigationItems else { return }
    guard !navigator.path.isEmpty else { return }

    // Build a new path without any older Authentication items that are
    // "equivalent" to the incoming one (leverages KMP's `matches` override).
    var newPath: [NavigationItem] = []
    newPath.reserveCapacity(navigator.path.count)

    for past in navigator.path {
        // Only consider removing past *authentication* items
        if past is AuthenticationNavigationItems,
           past.matches(navigationItem: item) {
            // drop it (this will remove both previous Main(friendlyId: …)
            // and previous SignOn(...) that your KMP `matches` treats as equivalent)
            continue
        }
        newPath.append(past)
    }

    navigator.path = newPath
}
