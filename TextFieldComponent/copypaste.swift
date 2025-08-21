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
