@MainActor
func popTo_iOS18(_ item: NavigationItem, inclusive: Bool = false, completion: (() -> Void)? = nil) {
    guard let idx = navigator.path.lastIndex(where: { $0.matches(navigationItem: item) }) else {
        completion?(); return
    }
    let keep = inclusive ? idx : idx + 1

    func step() {
        if navigator.path.count > keep {
            navigator.path.removeLast()
            DispatchQueue.main.async { step() }   // let UI flush between pops
        } else {
            completion?()
        }
    }
    DispatchQueue.main.async { step() }
}

@MainActor
func resetForSignOff(to login: NavigationItem) {
    // dismiss overlays tied to old screens
    viewModel.alert = nil
    viewModel.isSheetPresented = false

    // Pop down to root without making the path empty
    if !navigator.path.isEmpty {
        // pop to the first element (root) inclusively to clear all
        let root = navigator.path.first!
        popTo_iOS18(root, inclusive: true) {
            navigator.path.append(login)  // push login
        }
    } else {
        navigator.path = [login]
    }
}
