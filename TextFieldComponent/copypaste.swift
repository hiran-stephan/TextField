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


// iosAppTests/Mocks/TestItem.swift
@testable import iosApp

struct TestItem: NavigationItem, Equatable {
    let key: String
    let domainValue: String

    func domain() -> String { domainValue }
    func matches(navigationItemItem other: NavigationItem) -> Bool {
        guard let o = other as? TestItem else { return false }
        return key == o.key && domainValue == o.domainValue
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
