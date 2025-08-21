@MainActor
private func popTo(item: NavigationItem, inclusive: Bool = false) {
    guard let idx = navigator.path.lastIndex(where: { $0.matches(navigationItem: item) }) else { return }

    let itemsToRemove = inclusive ? (navigator.path.count - idx) : (navigator.path.count - idx - 1)
    guard itemsToRemove > 0 else { return }

    navigator.path = Array(navigator.path.dropLast(itemsToRemove))
}

@MainActor
private func popTo(item: NavigationItem, inclusive: Bool = false) {
    while let last = navigator.path.last, !last.matches(navigationItem: item) {
        navigator.path.removeLast()
    }

    if inclusive, !navigator.path.isEmpty {
        navigator.path.removeLast()
    }
}

@MainActor
private func popWhile(_ condition: (NavigationItem) -> Bool) {
    while let last = navigator.path.last, condition(last) {
        navigator.path.removeLast()
    }
}

@MainActor
func popTo(item: NavigationItem, inclusive: Bool = false) {
    popWhile { !$0.matches(navigationItem: item) }
    if inclusive, !navigator.path.isEmpty {
        navigator.path.removeLast()
    }
}

