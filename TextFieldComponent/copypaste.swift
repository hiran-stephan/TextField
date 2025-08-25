// iosAppTests/Mocks/TestNavigator.swift
@testable import iosApp

final class TestNavigator: Navigator {
    var id = UUID()
    var path: [NavigationItem] = []

    func removeLast() { _ = path.popLast() }
    func removeSubrange(_ range: Range<Int>) { path.removeSubrange(range) }
    func append(_ item: NavigationItem) { path.append(item) }
    var isEmpty: Bool { path.isEmpty }
    var count: Int { path.count }
}


import Foundation
@testable import iosApp

/// Mirrors the KMP NavigationItem contract for tests.
final class TestItem: NavigationItem, Equatable {

    let key: String        // just to make test assertions easy
    private let _domain: String
    private let _path: String

    init(key: String, domain: String, path: String = "") {
        self.key = key
        self._domain = domain
        self._path = path
        super.init()
    }

    // === NavigationItem overrides ===
    override func scheme() -> String { "cibcus" }

    override func domain() -> String { _domain }

    override func path() -> String { _path }

    /// Build the route the same way as Kotlin:
    /// scheme://domain  (+ "/path" only if path is non-empty)
    override func route() -> String {
        let base = "\(scheme())://\(_domain)"
        return _path.isEmpty ? base : "\(base)/\(_path)"
    }

    /// matches compares route strings, same as Kotlin `open fun matches(...) = route() == other.route()`
    override func matches(navigationItemItem other: NavigationItem) -> Bool {
        return self.route() == other.route()
    }

    // For XCTAssertEqual in tests
    static func == (lhs: TestItem, rhs: TestItem) -> Bool {
        lhs.key == rhs.key && lhs._domain == rhs._domain && lhs._path == rhs._path
    }
}



// iosAppTests/Mocks/SpyAppStateViewModel.swift
@testable import iosApp

final class SpyAppStateViewModel: AppStateViewModel {
    var didShowSplash: Bool?
    var lastLoading: (id: String, isLoading: Bool)?
    var lastErrors: [ProblemData]?
    var lastExitMessage: ExitMessage?

    func shouldShowSplashScreen(_ show: Bool) {
        didShowSplash = show
    }

    func updateLoading(requestId: String, isLoading: Bool) {
        lastLoading = (requestId, isLoading)
    }

    func showGlobalErrorDialog(errors: [ProblemData]) {
        lastErrors = errors
    }

    func showAppExitDialog(exitMessage: ExitMessage?, exitHandler: @escaping () -> Void) {
        lastExitMessage = exitMessage
    }
}


// iosAppTests/ApplicationNavigatorImplTests.swift
import XCTest
@testable import iosApp

final class ApplicationNavigatorImplTests: XCTestCase {

    private func makeSUT(
        startPath: [TestItem] = []
    ) -> (ApplicationNavigatorImpl, TestNavigator, SpyAppStateViewModel) {
        let nav = TestNavigator()
        nav.path = startPath
        let vm = SpyAppStateViewModel()

        let sut = ApplicationNavigatorImpl(
            viewModel: vm,
            navigator: nav
        )
        return (sut, nav, vm)
    }

    func test_navigateTo_appendsItem() {
        let (sut, nav, _) = makeSUT()
        let home = TestItem(key: "home", domainValue: "home")

        sut.navigateTo(item: home)

        XCTAssertEqual(nav.path as? [TestItem], [home])
    }

    func test_popBack_removesLastItem() {
        let a = TestItem(key: "a", domainValue: "d1")
        let b = TestItem(key: "b", domainValue: "d1")
        let (sut, nav, _) = makeSUT(startPath: [a, b])

        sut.popBack()

        XCTAssertEqual(nav.path as? [TestItem], [a])
    }

    func test_showSplashScreen_updatesViewModel() {
        let (sut, _, vm) = makeSUT()

        sut.showSplashScreen(shouldShowSplashScreen: true)

        XCTAssertTrue(vm.didShowSplash ?? false)
    }
}
