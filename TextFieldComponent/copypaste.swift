// MARK: - Clear stack until boundary

/// Pops from the top of the stack until a bottom-navigation boundary item is reached.
/// The boundary item itself is always kept.
/// If no boundary is found, the stack remains unchanged.
func clearStackUntilBottomNavBoundary(matchingRouter: FeatureRouter?,
                                      completion: (() -> Void)? = nil) {
    mutateOnMain { [weak self] in
        guard let self = self else { return }

        let path = self.navigator.path
        guard !path.isEmpty else { completion?(); return }

        // Walk from the end, find the first item that satisfies the boundary check
        var boundaryIndex: Int? = nil
        for i in stride(from: path.count - 1, through: 0, by: -1) {
            let pastItem = path[i]
            if self.checkIfPastItemHaveBottomNavigation(
                matchingRouter: matchingRouter,
                pastItem: pastItem,
                clearStack: true
            ) {
                boundaryIndex = i
                break
            }
        }

        // If boundary found, trim stack after it
        if let idx = boundaryIndex {
            if idx + 1 < self.navigator.path.count {
                self.navigator.path.removeSubrange(idx + 1..<self.navigator.path.count)
            }
        }
        // else: do nothing

        completion?()
    }
}

// Ensures you mutate on main just like your current DispatchQueue.main.async usage.
private func mutateOnMain(_ work: @escaping () -> Void) {
    if Thread.isMainThread {
        work()
    } else {
        DispatchQueue.main.async { work() }
    }
}

/// Pops back to the first/last occurrence of `item` in the stack.
/// - Parameters:
///   - item: The target item to pop to.
///   - inclusive: If true, the matched item is also removed.
///   - completion: Called after mutation.
func popTo(_ item: NavigationItem,
           inclusive: Bool = false,
           completion: (() -> Void)? = nil) {
    popTo(where: { $0.route() == item.route() }, inclusive: inclusive, completion: completion)
}


private func popTo(where matches: (NavigationItem) -> Bool,
                   inclusive: Bool = false,
                   completion: (() -> Void)? = nil) {
    mutateOnMain { [weak self] in
        guard let self = self else { completion?(); return }
        let path = self.navigator.path
        guard !path.isEmpty else { completion?(); return }

        guard let firstIdx = path.firstIndex(where: matches) else {
            // No-op if not found
            completion?(); return
        }

        // keep up to firstIdx (or exclude it if inclusive)
        let endToKeep = inclusive ? firstIdx : firstIdx + 1
        if endToKeep < self.navigator.path.count {
            self.navigator.path.removeSubrange(endToKeep..<self.navigator.path.count)
        }
        completion?()
    }
}


func popTo(_ item: NavigationItem,
           inclusive: Bool = false,
           completion: (() -> Void)? = nil) {
    // IMPORTANT: use .matches so SignOn will match Authentication already in stack
    popTo(where: { stackItem in
        stackItem.matches(navigationItem: item)   // or stackItem.matches(item) if bridged that way
    }, inclusive: inclusive, completion: completion)
}
