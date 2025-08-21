@MainActor
private func popTo(item: NavigationItem,
                   inclusive: Bool = false,
                   completion: (() -> Void)? = nil) {
    // Find the most recent occurrence (closest to top)
    guard let idx = navigator.path.lastIndex(where: { $0.matches(navigationItem: item) }) else {
        completion?()
        return
    }

    let keep = inclusive ? idx : (idx + 1)
    guard keep < navigator.path.count else {   // nothing to pop
        completion?()
        return
    }

    let newPath = Array(navigator.path.prefix(keep))
    guard newPath != navigator.path else {
        completion?()
        return
    }

    navigator.path = newPath   // no animation
    completion?()
}

