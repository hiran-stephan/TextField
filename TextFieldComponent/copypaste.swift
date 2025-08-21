@MainActor
func popTo_iOS18(_ item: NavigationItem, inclusive: Bool = false, completion: (() -> Void)? = nil) {
    guard let idx = navigator.path.lastIndex(where: { $0.matches(navigationItem: item) }) else {
        completion?(); return
    }
    let keep = inclusive ? idx : idx + 1
    guard keep < navigator.path.count else { completion?(); return }

    func step() {
        if navigator.path.count > keep {
            navigator.path.removeLast()   // one change per runloop
            DispatchQueue.main.async { step() }
        } else {
            completion?()
        }
    }
    DispatchQueue.main.async { step() }
}

@MainActor
func popTo_iOS18_force(_ item: NavigationItem, inclusive: Bool = false, completion: (() -> Void)? = nil) {
    guard let idx = navigator.path.lastIndex(where: { $0.matches(navigationItem: item) }) else {
        completion?(); return
    }
    let keep = inclusive ? idx : idx + 1
    guard keep < navigator.path.count else { completion?(); return }

    let target = Array(navigator.path.prefix(keep))

    // two distinct mutations so SwiftUI drops intermediate views
    navigator.path.removeAll()
    DispatchQueue.main.async {
        self.navigator.path = target
        completion?()
    }
}

