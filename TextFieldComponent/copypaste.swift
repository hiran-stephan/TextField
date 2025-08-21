if #available(iOS 18.0, *) {
        popTo_iOS18(item: item, inclusive: inclusive, completion: completion)
    } else {
        popTo_legacy(item: item, inclusive: inclusive, completion: completion)
    }

// iOS 18+: defer to next runloop (helps iOS 18 nav), use latest match
@available(iOS 18.0, *)
private func popTo_iOS18(item: NavigationItem,
                         inclusive: Bool,
                         completion: (() -> Void)?) {
    DispatchQueue.main.async { [weak self] in
        guard let self else { completion?(); return }
        guard let idx = self.navigator.path.lastIndex(where: { $0.matches(navigationItem: item) }) else {
            completion?(); return
        }
        let keep = inclusive ? idx : idx + 1
        guard keep < self.navigator.path.count else { completion?(); return }

        let newPath = Array(self.navigator.path.prefix(keep))
        guard newPath != self.navigator.path else { completion?(); return }
        self.navigator.path = newPath
        completion?()
    }
}


// iOS 17 and below: keep your current behavior (first match, immediate trim)
private func popTo_legacy(item: NavigationItem,
                          inclusive: Bool,
                          completion: (() -> Void)?) {
    DispatchQueue.main.async { [weak self] in
        guard let self else { completion?(); return }
        guard let idx = self.navigator.path.firstIndex(where: { $0.matches(navigationItem: item) }) else {
            completion?(); return
        }
        let keep = inclusive ? idx : idx + 1
        guard keep < self.navigator.path.count else { completion?(); return }

        let newPath = Array(self.navigator.path.prefix(keep))
        guard newPath != self.navigator.path else { completion?(); return }
        self.navigator.path = newPath
        completion?()
    }
}

