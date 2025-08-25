// iosApp/Services/Routing/RouterLookup.swift
import Foundation

enum RouterLookup {
  static var find: (String) -> FeatureRouter? = { domain in
    KoinApplication.findRouter(domain: domain)
  }
}

// before:
let router = KoinApplication.findRouter(domain: item.domain())
// after:
let router = RouterLookup.find(item.domain())

@testable import iosApp

struct TestFeatureRouter: FeatureRouter {
  let domain: String
  let hasBottomNavigation: Bool
}

func XCTAssertRoutesEqual(_ items: [NavigationItem], _ expected: [NavigationItem],
                          file: StaticString = #filePath, line: UInt = #line) {
  XCTAssertEqual(items.map { $0.route() }, expected.map { $0.route() }, file: file, line: line)
}


final class TestItem: NavigationItem {
  private let d: String, p: String
  init(domain: String, path: String = "") { self.d = domain; self.p = path; super.init() }
  override func domain() -> String { d }
  override func path()   -> String { p }
}


private func makeSUT(startPath: [NavigationItem] = [])
-> (sut: ApplicationNavigatorImpl, nav: Navigator, vm: AppStateViewModel) {
  let nav = Navigator(); nav.path = startPath
  let vm = AppStateViewModel()
  let sut = ApplicationNavigatorImpl(viewModel: vm, navigator: nav)
  return (sut, nav, vm)
}


import XCTest
@testable import iosApp

final class ApplicationNavigatorImpl_ClearStackTests: XCTestCase {

  override func setUp() {
    super.setUp()
    // default: no boundaries anywhere (tests override per-case)
    RouterLookup.find = { _ in nil }
  }

  // A) clearStack=true with boundaries → trims to LAST boundary, then appends
  @MainActor
  func test_navigateTo_clearStack_trimsToLastBoundary_thenAppends() {
    // Stack: auth(B), flow(NB), accounts(B), details
    let auth     = TestItem(domain: "auth")
    let flow1    = TestItem(domain: "flow")
    let accounts = TestItem(domain: "accounts")
    let details  = TestItem(domain: "accounts", path: "id")
    let dest     = TestItem(domain: "payments")

    // Mark boundaries
    RouterLookup.find = { domain in
      switch domain {
      case "auth":     return TestFeatureRouter(domain: domain, hasBottomNavigation: true)
      case "accounts": return TestFeatureRouter(domain: domain, hasBottomNavigation: true)
      case "flow":     return TestFeatureRouter(domain: domain, hasBottomNavigation: false)
      case "payments": return TestFeatureRouter(domain: domain, hasBottomNavigation: false)
      default:         return nil
      }
    }

    let (sut, nav, _) = makeSUT(startPath: [auth, flow1, accounts, details])
    sut.navigateTo(item: dest, clearStack: true)

    // Should keep up to the LAST boundary (accounts), then append dest
    XCTAssertRoutesEqual(nav.path, [auth, flow1, accounts, dest])
  }

  // B) clearStack=true with NO boundary → stack unchanged, just appends
  @MainActor
  func test_navigateTo_clearStack_noBoundary_keepsStack_thenAppends() {
    let a = TestItem(domain: "flow")
    let b = TestItem(domain: "flow", path: "x")
    let dest = TestItem(domain: "flow", path: "y")

    RouterLookup.find = { domain in
      TestFeatureRouter(domain: domain, hasBottomNavigation: false)
    }

    let (sut, nav, _) = makeSUT(startPath: [a, b])
    sut.navigateTo(item: dest, clearStack: true)

    XCTAssertRoutesEqual(nav.path, [a, b, dest])
  }

  // C) clearStack=true and last element itself is a boundary → trim after it (no-op), then append
  @MainActor
  func test_navigateTo_clearStack_whenTopIsBoundary_keepsTop_thenAppends() {
    let auth = TestItem(domain: "auth")            // boundary at top
    let dest = TestItem(domain: "auth", path: "next")

    RouterLookup.find = { domain in
      TestFeatureRouter(domain: domain, hasBottomNavigation: domain == "auth")
    }

    let (sut, nav, _) = makeSUT(startPath: [auth])
    sut.navigateTo(item: dest, clearStack: true)

    XCTAssertRoutesEqual(nav.path, [auth, dest])
  }

  // D) id bump after trimming (UI refresh poke)
  @MainActor
  func test_navigateTo_clearStack_trimmingChangesNavigatorId() {
    let home = TestItem(domain: "home")            // boundary
    let inner = TestItem(domain: "flow")           // non-boundary
    let dest = TestItem(domain: "payments")

    RouterLookup.find = { domain in
      switch domain {
      case "home": return TestFeatureRouter(domain: domain, hasBottomNavigation: true)
      default:     return TestFeatureRouter(domain: domain, hasBottomNavigation: false)
      }
    }

    let (sut, nav, _) = makeSUT(startPath: [home, inner])
    let oldId = nav.id

    sut.navigateTo(item: dest, clearStack: true)

    XCTAssertNotEqual(nav.id, oldId)               // id was reassigned after removeSubrange
    XCTAssertRoutesEqual(nav.path, [home, dest])
  }

  // E) clearStack=false → never trims, just appends
  @MainActor
  func test_navigateTo_withoutClearStack_justAppends() {
    let a = TestItem(domain: "accounts")
    let dest = TestItem(domain: "payments")

    // Even if accounts is a boundary, with clearStack=false it must not trim
    RouterLookup.find = { domain in
      TestFeatureRouter(domain: domain, hasBottomNavigation: domain == "accounts")
    }

    let (sut, nav, _) = makeSUT(startPath: [a])
    sut.navigateTo(item: dest, clearStack: false)

    XCTAssertRoutesEqual(nav.path, [a, dest])
  }
}

