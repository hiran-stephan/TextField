import XCTest
@testable import iosApp

// Compare by NavigationItem contract (route string), not object identity
func XCTAssertRoutesEqual(
  _ items: [NavigationItem],
  _ expected: [NavigationItem],
  file: StaticString = #filePath,
  line: UInt = #line
) {
  XCTAssertEqual(items.map { $0.route() },
                 expected.map { $0.route() },
                 file: file, line: line)
}

// Test item that only overrides the abstract bits
final class TestItem: NavigationItem {
  private let d: String, p: String
  let key: String
  init(key: String, domain: String, path: String = "") {
    self.key = key; self.d = domain; self.p = path
    super.init()
  }
  override func domain() -> String { d }
  override func path()   -> String { p }
}

// SUT factory
private func makeSUT(
  startPath: [NavigationItem] = []
) -> (sut: ApplicationNavigatorImpl, nav: Navigator, vm: AppStateViewModel) {
  let nav = Navigator(); nav.path = startPath
  let vm  = AppStateViewModel()
  let sut = ApplicationNavigatorImpl(viewModel: vm, navigator: nav)
  return (sut, nav, vm)
}


final class ApplicationNavigatorImplTests: XCTestCase {

  // 1) push
  @MainActor
  func test_navigateTo_appendsItem() {
    let (sut, nav, _) = makeSUT()
    let home = TestItem(key: "home", domain: "home")

    sut.navigateTo(item: home)

    XCTAssertRoutesEqual(nav.path, [home])
  }

  // 2) popBack
  @MainActor
  func test_popBack_removesLast() {
    let a = TestItem(key: "a", domain: "d")
    let b = TestItem(key: "b", domain: "d")
    let (sut, nav, _) = makeSUT(startPath: [a, b])

    sut.popBack()

    XCTAssertRoutesEqual(nav.path, [a])
  }

  // 3) popTo: no match → no-op
  @MainActor
  func test_popTo_whenNoMatch_doesNothing() {
    let a = TestItem(key: "a", domain: "d")
    let b = TestItem(key: "b", domain: "d")
    let (sut, nav, _) = makeSUT(startPath: [a, b])

    sut.popTo(item: TestItem(key: "zzz", domain: "d"), inclusive: true)

    XCTAssertRoutesEqual(nav.path, [a, b])
  }

  // 4) inclusive fencepost
  @MainActor
  func test_popTo_inclusiveFalse_keepsMatched() {
    let a = TestItem(key: "a", domain: "d")
    let b = TestItem(key: "b", domain: "d")
    let (sut, nav, _) = makeSUT(startPath: [a, b])

    sut.popTo(item: b, inclusive: false)

    XCTAssertRoutesEqual(nav.path, [a, b])
  }

  @MainActor
  func test_popTo_inclusiveTrue_removesMatched() {
    let a = TestItem(key: "a", domain: "d")
    let b = TestItem(key: "b", domain: "d")
    let (sut, nav, _) = makeSUT(startPath: [a, b])

    sut.popTo(item: b, inclusive: true)

    XCTAssertRoutesEqual(nav.path, [a])
  }

  @MainActor
  func test_popTo_inclusiveTrue_onFirstItem_resultsEmpty() {
    let a = TestItem(key: "a", domain: "d")
    let (sut, nav, _) = makeSUT(startPath: [a])

    sut.popTo(item: a, inclusive: true)

    XCTAssertTrue(nav.path.isEmpty)
  }

  // 5) id bump (UI poke) after trim
  @MainActor
  func test_idChangesAfterTrim_onPopToInclusive() {
    let a = TestItem(key: "a", domain: "d")
    let b = TestItem(key: "b", domain: "d")
    let (sut, nav, _) = makeSUT(startPath: [a, b])
    let old = nav.id

    sut.popTo(item: b, inclusive: true)

    XCTAssertNotEqual(nav.id, old)
    XCTAssertRoutesEqual(nav.path, [a])
  }

  // 6) ViewModel side-effects (use real VM)
  @MainActor
  func test_showSplashScreen_updatesViewModel() {
    let (sut, _, vm) = makeSUT()

    sut.showSplashScreen(shouldShowSplashScreen: true)

    XCTAssertTrue(vm.shouldShowSplashScreen)
  }

  @MainActor
  func test_trackBlockingLoading_updatesLoadingSet() {
    let (sut, _, vm) = makeSUT()

    sut.trackBlockingLoading(requestId: "X", isLoading: true)
    XCTAssertTrue(vm.loading.contains("X"))

    sut.trackBlockingLoading(requestId: "X", isLoading: false)
    XCTAssertFalse(vm.loading.contains("X"))
  }

  @MainActor
  func test_showGlobalErrorDialog_setsErrors() {
    let (sut, _, vm) = makeSUT()
    let p = ProblemData(type: "t", field: "f", code: "c")

    sut.showGlobalErrorDialog(errors: [p])

    XCTAssertEqual(vm.errors.count, 1)
    XCTAssertEqual(vm.errors.first?.type, "t")
  }
}
