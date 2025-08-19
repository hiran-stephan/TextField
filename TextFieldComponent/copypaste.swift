/**
 * Determines whether this navigation item matches the given [navigationItem].
 *
 * This override extends the default comparison to also consider the
 * `ROUTE_SIGN_ON` route equivalent. Useful for treating SignOn and
 * Authentication navigation items as the same target.
 *
 * @param navigationItem the item to compare against
 * @return `true` if this item is considered equivalent to [navigationItem],
 *         `false` otherwise
 */
override fun matches(navigationItem: NavigationItem): Boolean {
    return super.matches(navigationItem) ||
           ROUTE_SIGN_ON.route() == navigationItem.route()
}

/// Pops the navigation stack back to the given item.
/// - Parameters:
///   - item: The target item to pop to.
///   - inclusive: If `true`, the matched item is also removed.
///   - completion: An optional closure called after the operation.
func popToItem(_ item: NavigationItem,
               inclusive: Bool = false,
               completion: (() -> Void)? = nil) {
    popTo(where: { stackItem in
        stackItem.matches(navigationItem: item)
    }, inclusive: inclusive, completion: completion)
}


/// Pops the navigation stack back to the first item that satisfies the given condition.
/// - Parameters:
///   - matches: A predicate used to identify the target item in the stack.
///   - inclusive: If `true`, the matched item is also removed.
///   - completion: An optional closure called after the operation.
/// - Note: If no matching item is found, no changes are made.
private func popTo(where matches: @escaping (NavigationItem) -> Bool,
                   inclusive: Bool = false,
                   completion: (() -> Void)? = nil) {
    mutateOnMain { [weak self] in
        guard let self = self else { completion?(); return }
        let path = self.navigator.path
        guard !path.isEmpty else { completion?(); return }

        guard let firstIdx = path.firstIndex(where: matches) else {
            completion?(); return
        }

        let endToKeep = inclusive ? firstIdx : firstIdx + 1
        if endToKeep < self.navigator.path.count {
            self.navigator.path.removeSubrange(endToKeep..<self.navigator.path.count)
        }
        completion?()
    }
}


/// Navigates to the given item, with optional stack clearing before appending.
/// - Parameters:
///   - item: The destination navigation item.
///   - clearStack: If `true`, clears the stack until the bottom navigation boundary
///                 (if present) before appending the new item.
func navigateTo(item: NavigationItem, clearStack: Bool) {
    if clearStack {
        let router = KoinApplication.findRouter(domain: item.domain())
        clearStackUntilBottomNavBoundary(matchingRouter: router)
        navigator.path.append(item)
    } else {
        navigator.path.append(item)
    }
}


/// Clears the navigation stack until a bottom-navigation boundary item is found.
/// The boundary item itself is always kept.
/// If no boundary is found, the stack remains unchanged.
/// - Parameter matchingRouter: The router used to evaluate bottom-navigation boundaries.
func clearStackUntilBottomNavBoundary(matchingRouter: FeatureRouter?) {
    ...
}


/// Checks if the given past navigation item belongs to a bottom-navigation domain.
/// Used to decide whether the stack should be cleared up to this item.
/// - Parameters:
///   - matchingRouter: The router associated with the current domain.
///   - pastItem: The navigation item being evaluated.
///   - clearStack: Indicates if the check is being performed as part of a clear-stack operation.
/// - Returns: `true` if the item is part of bottom navigation and should act as a boundary, otherwise `false`.
private func checkIfPastItemHaveBottomNavigation(
    matchingRouter: FeatureRouter?,
    pastItem: NavigationItem,
    clearStack: Bool
) -> Bool {
    ...
}



