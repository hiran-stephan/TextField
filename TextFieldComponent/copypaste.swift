func pushUnique(_ item: NavigationItem) {
    DispatchQueue.main.async { [weak self] in
        guard let self = self else { return }
        var p = self.navigator.path.filter { !$0.matches(navigationItem: item) }
        p.append(item)

        guard p != self.navigator.path else { return }
        var t = Transaction()
        t.disablesAnimations = true
        withTransaction(t) {
            self.navigator.path = p
        }
    }
}

private func trimToBottomNavBoundary() {
    guard let idx = navigator.path.lastIndex(where: { past in
        KoinApplication.findRouter(domain: past.domain()).hasBottomNavigation
    }) else { return }

    guard idx + 1 < navigator.path.count else { return }

    let trimmed = Array(navigator.path.prefix(idx + 1))
    guard trimmed != navigator.path else { return }
    navigator.path = trimmed
}
