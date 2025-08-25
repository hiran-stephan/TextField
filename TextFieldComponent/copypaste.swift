/// Top-level application navigator.
///
/// Invariants:
/// - `path` contains a linear back stack of `NavigationItem`s.
/// - `id` is bumped (new UUID) whenever a destructive mutation occurs so
///   SwiftUI recomputes `NavigationStack`.
/// Complexity:
/// - All stack searches and trims are O(n) worst-case.
final class ApplicationNavigatorImpl: ApplicationNavigator { ... }


/// Pushes a new destination on the back stack.
/// - Parameter item: The destination to append.
/// - Note: This is a pure append; it never trims and does not consult boundaries.
@MainActor
func navigateTo(item: NavigationItem) { ... }


/// Pushes a destination, optionally clearing the stack up to the most recent
/// bottom-navigation boundary **before** appending.
/// - Parameters:
///   - item: The destination to append after any clearing.
///   - clearStack: If `true`, the stack is trimmed to the last boundary
///     (walking from the end) **and that boundary is kept**. If no boundary
///     exists, the stack is left unchanged. If `false`, no trimming occurs.
/// - Important: The boundary search walks from the end toward the start and
///   stops on the **first** item that `checkIfPastItemHaveBottomNavigation`
///   marks as a boundary.
/// - Side effects: Bumps `id` only when a trim happens.
@MainActor
func navigateTo(item: NavigationItem, clearStack: Bool) { ... }

/// Pops back to the first stack element matching `matches`, scanning from the
/// start (oldest) of the stack.
/// - Parameters:
///   - matches: Predicate to identify the target item.
///   - inclusive: If `true`, the matched item is also removed; if `false`, it is kept.
///   - completion: Optional callback after mutation.
/// - Behavior:
///   - If no element matches, the stack is unchanged (no-op).
///   - When `inclusive == false`, the result keeps items up to (and including)
///     the first match (earliest).
///   - When `inclusive == true`, the result keeps items strictly **before** the
///     first match.
/// - Side effects: Bumps `id` only when a trim happens.
private func popTo(where matches: @escaping (NavigationItem) -> Bool,
                   inclusive: Bool = false,
                   completion: (() -> Void)? = nil) { ... }


/// Convenience: pops back to the first element whose route equals `item.route()`.
/// - Parameters:
///   - item: Logical route to match (domain + path), not object identity.
///   - inclusive: If `true`, the matched element is also removed.
/// - SeeAlso: `popTo(where:inclusive:)`.
func popTo(item: NavigationItem, inclusive: Bool = false) { ... }


/// Trims the back stack to the **last** bottom-navigation boundary.
/// - Parameter matchingRouter: Router used to classify boundaries for the
///   current operation (e.g., treating `auth` as bottom-nav only when called
///   via clear-stack flows).
/// - Behavior:
///   - Walks from end → start; the first element that returns `true` from
///     `checkIfPastItemHaveBottomNavigation` is the boundary.
///   - If found, removes every element **after** that boundary (boundary kept).
///   - If none, no-ops.
/// - Side effects: Bumps `id` when trimming occurs.
private func clearStackToBottomNavigation(matchingRouter: FeatureRouter?) { ... }



/// Determines whether a historical item should be treated as a bottom-nav
/// boundary for the current operation.
/// - Parameters:
///   - matchingRouter: The router associated with the **current** domain.
///   - pastItem: The item being evaluated.
///   - clearStack: Whether this check is being performed for a clear-stack flow.
/// - Returns: `true` if `pastItem` belongs to a bottom-nav domain.
/// - Note: For clear-stack flows, we also treat `authentication` and `signon`
///   domains as boundaries to keep the app’s home/signon root.
private func checkIfPastItemHaveBottomNavigation(
  matchingRouter: FeatureRouter?,
  pastItem: NavigationItem,
  clearStack: Bool
) -> Bool { ... }


/// Tests verify navigation *by route contract* (domain + path), not identity.
/// Use `XCTAssertRoutesEqual` to compare logical routes.

/// Asserts two stacks are equal by their `route()` values.
/// This avoids coupling to test item identity.
func XCTAssertRoutesEqual(
  _ items: [NavigationItem],
  _ expected: [NavigationItem],
  file: StaticString = #filePath,
  line: UInt = #line
) { ... }


// MARK: - navigateTo + clearStack

/// clearStack=true with boundaries → trims to the **last** boundary, then appends.
@MainActor func test_navigateTo_clearStack_trimsToLastBoundary_thenAppends() { ... }

/// clearStack=true and there is NO boundary → stack unchanged, just appends.
@MainActor func test_navigateTo_clearStack_noBoundary_keepsStack_thenAppends() { ... }

/// clearStack=true and top is already a boundary → no trim; boundary kept; append.
@MainActor func test_navigateTo_clearStack_whenTopIsBoundary_keepsTop_thenAppends() { ... }

/// `id` bump occurs only when a trim actually happens.
@MainActor func test_navigateTo_clearStack_trimmingChangesNavigatorId() { ... }

/// clearStack=false → never trims, regardless of boundaries.
@MainActor func test_navigateTo_withoutClearStack_justAppends() { ... }

// MARK: - push / popBack

/// Plain push appends a single element.
@MainActor func test_navigateTo_appendsItem() { ... }

/// popBack removes the last element.
@MainActor func test_popBack_removesLast() { ... }

// MARK: - popTo (route matching)

/// No match in popTo → no-op (document current behavior).
@MainActor func test_popTo_whenNoMatch_doesNothing() { ... }

/// Duplicate logical routes: popTo picks the **first** match (earliest).
@MainActor func test_popTo_withDuplicateRoutes_trimsToFirstMatch() { ... }

// MARK: - popTo inclusive fence-post

/// inclusive=false → keep the matched element.
@MainActor func test_popTo_inclusiveFalse_keepsMatched() { ... }

/// inclusive=true → remove the matched element.
@MainActor func test_popTo_inclusiveTrue_removesMatched() { ... }

/// inclusive=true when the first element matches → results in an empty stack.
@MainActor func test_popTo_inclusiveTrue_onFirstItem_resultsEmpty() { ... }

/// Trimming via inclusive popTo bumps `id` (UI poke).
@MainActor func test_idChangesAfterTrim_onPopToInclusive() { ... }
