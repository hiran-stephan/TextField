@MainActor
func navigateTo(item: NavigationItem, clearStack: Bool) {
    if clearStack {
        let router = RouterLookup.find(item.domain())
        if !clearStackToBottomNavigation(matchingRouter: router) {
            // Android-like fallback: keep Auth root if present
            popTo(AuthenticationNavigationItems.Main.shared, inclusive: false)
        }
    }
    navigator.path.append(item)
}

// Return true if a boundary was found & trimmed
@discardableResult
private func clearStackToBottomNavigation(matchingRouter: FeatureRouter?) -> Bool {
    var boundaryIndex: Int? = nil
    let path = navigator.path
    for i in stride(from: path.count - 1, through: 0, by: -1) {
        if checkIfPastItemHaveBottomNavigation(matchingRouter: matchingRouter,
                                               pastItem: path[i],
                                               clearStack: true) {
            boundaryIndex = i
            break
        }
    }
    guard let idx = boundaryIndex, idx + 1 < navigator.path.count else { return false }
    navigator.path.removeSubrange(idx + 1 ..< navigator.path.count) // keep boundary
    navigator.id = UUID()
    return true
}
