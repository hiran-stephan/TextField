@MainActor
func popTo_iOS18(_ item: NavigationItem, inclusive: Bool = false, completion: (() -> Void)? = nil) {
    guard let idx = navigator.path.lastIndex(where: { $0.matches(navigationItem: item) }) else {
        completion?(); return
    }
    let keep = inclusive ? idx : idx + 1
    func step() {
        if navigator.path.count > keep {
            navigator.path.removeLast()
            DispatchQueue.main.async { step() }   // let UI flush
        } else {
            completion?()
        }
    }
    DispatchQueue.main.async { step() }
}
