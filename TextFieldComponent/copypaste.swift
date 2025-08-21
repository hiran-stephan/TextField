private func popTo(
    where matches: @escaping (NavigationItem) -> Bool,
    inclusive: Bool = false,
    completion: (() -> Void)? = nil
) {
    mutateOnMain { [weak self] in
        guard let self else { completion?(); return }
        let path = self.navigator.path
        guard !path.isEmpty else { completion?(); return }

        // iOS 18 prefers the most recent match; legacy kept the first.
        let matchIndex: Int?
        if #available(iOS 18.0, *) {
            matchIndex = path.lastIndex(where: matches)
        } else {
            matchIndex = path.firstIndex(where: matches)
        }
        guard let idx = matchIndex else { completion?(); return }

        let endToKeep = inclusive ? idx : (idx + 1)
        guard endToKeep < self.navigator.path.count else { completion?(); return }

        if #available(iOS 18.0, *) {
            // Pop one-by-one across runloop turns so intermediate screens actually unmount.
            func step() {
                if self.navigator.path.count > endToKeep {
                    UIView.performWithoutAnimation {    // keep it snappy, no animation
                        _ = self.navigator.path.removeLast()
                    }
                    DispatchQueue.main.async { step() }
                } else {
                    // bump epoch once at the end (matches your current pattern)
                    self.navigator.id = UUID()
                    completion?()
                }
            }
            DispatchQueue.main.async { step() }
        } else {
            // Legacy: single trim works fine
            UIView.performWithoutAnimation {
                self.navigator.path.removeSubrange(endToKeep..<self.navigator.path.count)
            }
            self.navigator.id = UUID()
            completion?()
        }
    }
}
