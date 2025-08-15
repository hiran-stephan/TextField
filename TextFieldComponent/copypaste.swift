func popTo(item: NavigationItem?,
           inclusive: Bool,
           clearStack: Bool,
           completion: (() -> Void)? = nil) {

    // 1) Special case: keep the FIRST authentication item, drop everything after it.
    let authDomain = NavigationItems.shared.authentication.DOMAIN_SIGNON
    if item?.domain() == authDomain,
       let firstAuthIndex = navigator.path.firstIndex(where: { $0.domain() == authDomain }) {
        navigator.path.removeSubrange((firstAuthIndex + 1)..<navigator.path.count)
        completion?()
        return
    }

    // 2) General pop logic
    let router = item.flatMap { KoinApplication.findRouter(domain: $0.domain()) }

    var i = navigator.path.count - 1
    while i >= 0 {
        let pastItem = navigator.path[i]

        // A) Found the target route and we're clearing up to it
        if let target = item, clearStack, pastItem.route() == target.route() {
            if inclusive {
                // remove including the matched item
                navigator.path.removeSubrange(i..<navigator.path.count)
            } else {
                // keep matched, drop items after it
                if i + 1 < navigator.path.count {
                    navigator.path.removeSubrange((i + 1)..<navigator.path.count)
                }
            }
            break
        }

        // B) Stop if bottom navigation boundary says so
        if checkIfPastItemHaveBottomNavigation(
            matchingRouter: router,
            pastItem: pastItem,
            clearStack: clearStack
        ) {
            break
        }

        // C) Otherwise keep popping
        navigator.path.removeLast()
        i -= 1
    }

    completion?()
}
