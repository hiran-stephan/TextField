@MainActor
func clearStackToFirstBoundary(matchingRouter: FeatureRouter?) {
    let path = navigator.path
    guard !path.isEmpty else { return }

    // first match from the *front*
    let boundaryIndex = path.firstIndex { past in
        self.checkIfPastItemHaveBottomNavigation(
            matchingRouter: matchingRouter,
            pastItem: past,
            clearStack: true
        )
    }
    guard let idx = boundaryIndex else { return }

    // OPTION A: keep up to (and including) the boundary, drop everything after
    navigator.path = Array(path.prefix(idx + 1))

    // OPTION B: drop everything before the boundary, keep boundary and after
    // navigator.path = Array(path.suffix(from: idx))
}
