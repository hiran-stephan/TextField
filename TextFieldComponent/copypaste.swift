@MainActor
func clearStackUntilBottomNavBoundary(
    matchingRouter: FeatureRouter?,
    thenPush item: NavigationItem? = nil
) async {
    guard !navigator.path.isEmpty else {
        if let item { navigator.path.append(item) }
        return
    }

    // find boundary
    var boundaryIndex: Int? = nil
    for i in stride(from: navigator.path.count - 1, through: 0, by: -1) {
        let pastItem = navigator.path[i]
        if checkIfPastItemHaveBottomNavigation(
            matchingRouter: matchingRouter,
            pastItem: pastItem,
            clearStack: true
        ) {
            boundaryIndex = i
            break
        }
    }

    if let idx = boundaryIndex, idx + 1 < navigator.path.count {
        navigator.path.removeSubrange(idx + 1 ..< navigator.path.count)
    } // else: no boundary -> no-op

    // ensure the trim is processed before we push
    guard let item else { return }
    await Task.yield()            // << one tick on the main actor
    navigator.path.append(item)
}

@MainActor
func navigateTo(item: NavigationItem, clearStack: Bool) async {
    let router = KoinApplication.findRouter(domain: item.domain())
    if clearStack {
        await clearStackUntilBottomNavBoundary(matchingRouter: router, thenPush: item)
    } else {
        navigator.path.append(item)
    }
}


private func pathContains(_ item: NavigationItem) -> Bool {
    navigator.path.firstIndex { stackItem in
        stackItem.matches(navigationItem: item)
    } != nil
}

@MainActor
func navigateTo(item: NavigationItem, clearStack: Bool) {
    let router = KoinApplication.findRouter(domain: item.domain())

    if clearStack, pathContains(item) {
        // Pop until bottom-nav boundary only when a matching item already exists
        clearStackUntilBottomNavBoundary(matchingRouter: router)
        // optional: let the pop render before push
        // await Task.yield()   // if you made this async
    }

    navigator.path.append(item)
}
