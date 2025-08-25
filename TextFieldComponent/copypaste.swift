import XCTest
@testable import iosApp

// MARK: - A concrete test NavigationItem that mirrors KMP behavior
// KMP NavigationItem builds route as: "cibcus://<domain>" (+ "/<path>" if non-empty)
// and matches by comparing route() strings. We mirror that here.

final class TestItem: NavigationItem, Equatable {
    let key: String
    private let d: String
    private let p: String

    init(key: String, domain: String, path: String = "") {
        self.key = key
        self.d = domain
        self.p = path
        super.init()
    }

    override func scheme() -> String { "cibcus" }
    override func domain() -> String { d }
    override func path()   -> String { p }

    override func route() -> String {
        let base = "\(scheme())://\(d)"
        return p.isEmpty ? base : "\(base)/\(p)"
    }

    override func matches(navigationItemItem other: NavigationItem) -> Bool {
        self.route() == other.route()
    }

    static func == (lhs: TestItem, rhs: TestItem) -> Bool {
        lhs.key == rhs.key && lhs.d == rhs.d && lhs.p == rhs.p
    }
}

// MARK: - Test SUT factory
private func makeSUT(
    startPath: [NavigationItem] = []
) -> (sut: ApplicationNavigatorImpl, nav: Navigator, vm: AppStateViewModel) {
    let nav = Navigator()
    nav.path = startPath
    let vm = AppStateViewModel() // use real VM (final class) and assert state

    let sut = ApplicationNavigatorImpl(viewModel: vm, navigator: nav)
    return (sut, nav, vm)
}

// MARK: - Tests

final class ApplicationNavigatorImplTests: XCTestCase {

    // 1) basic push
    func test_navigateTo_appendsItem() {
        let (sut, nav, _) = makeSUT()
        let home = TestItem(key: "home", domain: "home")

        sut.navigateTo(item: home)

        XCTAssertEqual(nav.path as? [TestItem], [home])
    }

    // 2) popBack removes last
    func test_popBack_removesLast() {
        let a = TestItem(key: "a", domain: "d")
        let b = TestItem(key: "b", domain: "d")
        let (sut, nav, _) = makeSUT(startPath: [a, b])

        sut.popBack()

        XCTAssertEqual(nav.path as? [TestItem], [a])
    }

    // 3) popTo: no match → no-op
    func test_popTo_whenNoMatch_doesNothing() {
        let a = TestItem(key: "a", domain: "d")
        let b = TestItem(key: "b", domain: "d")
        let (sut, nav, _) = makeSUT(startPath: [a, b])

        sut.popTo(item: TestItem(key: "zzz", domain: "d"), inclusive: true)

        XCTAssertEqual(nav.path as? [TestItem], [a, b])
    }

    // 4) inclusive fencepost checks
    func test_popTo_inclusiveFalse_keepsMatched_exactFencepost() {
        let a = TestItem(key: "a", domain: "d")
        let b = TestItem(key: "b", domain: "d")
        let (sut, nav, _) = makeSUT(startPath: [a, b])

        sut.popTo(item: b, inclusive: false)

        XCTAssertEqual(nav.path as? [TestItem], [a, b])
    }

    func test_popTo_inclusiveTrue_removesMatched_exactFencepost() {
        let a = TestItem(key: "a", domain: "d")
        let b = TestItem(key: "b", domain: "d")
        let (sut, nav, _) = makeSUT(startPath: [a, b])

        sut.popTo(item: b, inclusive: true)

        XCTAssertEqual(nav.path as? [TestItem], [a])
    }

    func test_popTo_inclusiveTrue_onFirstItem_resultsEmpty() {
        let a = TestItem(key: "a", domain: "d")
        let (sut, nav, _) = makeSUT(startPath: [a])

        sut.popTo(item: a, inclusive: true)

        XCTAssertTrue(nav.path.isEmpty)
    }

    // 5) id bump after trims (UI "poke")
    func test_idChangesAfterTrim_onPopToInclusive() {
        let a = TestItem(key: "a", domain: "d")
        let b = TestItem(key: "b", domain: "d")
        let (sut, nav, _) = makeSUT(startPath: [a, b])
        let oldId = nav.id

        sut.popTo(item: b, inclusive: true)

        XCTAssertNotEqual(nav.id, oldId)
        XCTAssertEqual(nav.path as? [TestItem], [a])
    }

    // 6) ViewModel side-effects (use real VM, assert state)
    func test_showSplashScreen_updatesViewModel() {
        let (sut, _, vm) = makeSUT()

        sut.showSplashScreen(shouldShowSplashScreen: true)

        XCTAssertTrue(vm.shouldShowSplashScreen)
    }

    func test_trackBlockingLoading_updatesLoadingSet() {
        let (sut, _, vm) = makeSUT()

        sut.trackBlockingLoading(requestId: "X", isLoading: true)
        XCTAssertTrue(vm.loading.contains("X"))

        sut.trackBlockingLoading(requestId: "X", isLoading: false)
        XCTAssertFalse(vm.loading.contains("X"))
    }

    func test_showGlobalErrorDialog_setsErrors() {
        let (sut, _, vm) = makeSUT()
        let p = ProblemData(type: "t", field: "f", code: "c")

        sut.showGlobalErrorDialog(errors: [p])

        XCTAssertEqual(vm.errors.count, 1)
        XCTAssertEqual(vm.errors.first?.type, "t")
    }

    // 7) Predicate-based popTo (via a tiny test-only wrapper below)
    func test_predicatePopTo_keepsMatched_whenInclusiveFalse() {
        let a = TestItem(key: "a", domain: "d")
        let b = TestItem(key: "special", domain: "d")
        let c = TestItem(key: "c", domain: "d")
        let (sut, nav, _) = makeSUT(startPath: [a, b, c])

        sut.__testing_popTo(where: { ($0 as? TestItem)?.key == "special" }, inclusive: false)

        XCTAssertEqual(nav.path as? [TestItem], [a, b])
    }

    // --- Boundary walk test (optional) ---
    //
    // NOTE: This requires a tiny test seam so we can control router lookups.
    // If you add the seam described below, uncomment this test.
    //
    // func test_clearStack_walksFromEnd_andStopsAtFirstBoundary() {
    //     let auth    = TestItem(key: "signon",   domain: "auth")
    //     let flow1   = TestItem(key: "flow1",    domain: "x")
    //     let accounts= TestItem(key: "accounts", domain: "accounts")
    //     let details = TestItem(key: "details",  domain: "accounts", path: "id")
    //     let dest    = TestItem(key: "next",     domain: "payments")
    //
    //     RouterLookup.find = { domain in            // ← seam
    //         switch domain {
    //         case "auth":     return TestFeatureRouter(domain: "auth", hasBottomNavigation: true)
    //         case "accounts": return TestFeatureRouter(domain: "accounts", hasBottomNavigation: true)
    //         case "x":        return TestFeatureRouter(domain: "x", hasBottomNavigation: false)
    //         case "payments": return TestFeatureRouter(domain: "payments", hasBottomNavigation: false)
    //         default:         return nil
    //         }
    //     }
    //
    //     let (sut, nav, _) = makeSUT(startPath: [auth, flow1, accounts, details])
    //     sut.navigateTo(item: dest, clearStack: true)
    //
    //     XCTAssertEqual(nav.path as? [TestItem], [auth, flow1, accounts, dest])
    // }
}

// MARK: - Private testing hook to access the private predicate popTo
#if DEBUG
@_spi(Testing)
extension ApplicationNavigatorImpl {
    func __testing_popTo(where matches: @escaping (NavigationItem) -> Bool,
                         inclusive: Bool = false) {
        popTo(where: matches, inclusive: inclusive, completion: nil)
    }
}
#endif


xcodebuild test \
  -scheme iosApp \
  -only-testing:ApplicationNavigatorImplTests
