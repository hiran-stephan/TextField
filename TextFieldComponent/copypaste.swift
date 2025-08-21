@MainActor
func replaceWithTop(_ item: NavigationItem) {
    var p = navigator.path

    if let idx = p.lastIndex(where: { $0.matches(navigationItem: item) }) {
        // remove INCLUDING the found item and everything above it
        p = Array(p.prefix(idx))
    }
    // (optional) ensure uniqueness in case there are older duplicates below
    p.removeAll { $0.matches(navigationItem: item) }

    p.append(item)

    guard p != navigator.path else { return }
    navigator.path = p
}
