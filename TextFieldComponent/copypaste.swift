@inline(__always)
private func withoutAnimation(_ body: () -> Void) {
    // SwiftUI side
    var t = Transaction()
    t.animation = nil
    t.disablesAnimations = true
    withTransaction(t) {
        // UIKit side (covers the backport’s UINavigationController ops)
        UIView.performWithoutAnimation {
            body()
            // If you use an epoch/id bump, do it inside here too
        }
    }
}

private func popTo(where matches: @escaping (NavigationItem) -> Bool,
                   inclusive: Bool = false,
                   completion: (() -> Void)? = nil) {
    mutateOnMain { [weak self] in
        guard let self else { completion?(); return }
        let path = self.navigator.path
        guard !path.isEmpty else { completion?(); return }
        guard let firstIdx = path.firstIndex(where: matches) else { completion?(); return }

        let endToKeep = inclusive ? firstIdx : firstIdx + 1
        guard endToKeep < self.navigator.path.count else { completion?(); return }

        withoutAnimation {
            self.navigator.path.removeSubrange(endToKeep..<self.navigator.path.count)
            self.navigator.id = UUID() // your epoch/ID bump
        }
        completion?()
    }
}


func clearStackToBottomNavigation(matchingRouter: FeatureRouter?) {
    mutateOnMain { [weak self] in
        guard let self else { return }
        let path = self.navigator.path
        guard !path.isEmpty else { return }

        guard let idx = path.lastIndex(where: {
            KoinApplication.findRouter(domain: $0.domain()).hasBottomNavigation
        }) else { return }

        guard idx + 1 < self.navigator.path.count else { return }

        withoutAnimation {
            self.navigator.path.removeSubrange((idx + 1)..<self.navigator.path.count)
            self.navigator.id = UUID()
        }
    }
}

