
override func setUp() {
    super.setUp()
    savedFind = RouterLookup.find
    // Default map: no boundaries unless a test overrides.
    RouterLookup.find = { _ in nil }
}

override func tearDown() {
    RouterLookup.find = savedFind
    super.tearDown()
}


// --------------------
    // clearStack behavior
    // --------------------

    /// A) clearStack=true with boundaries → trim to LAST boundary, then append.
    func test_navigateTo_clearStack_trimsToLastBoundary_thenAppends() {
        // Stack: auth(B), flow(NB), accounts(B), details
        let auth     = TestItem(domain: "auth")
        let flow1    = TestItem(domain: "flow")
        let accounts = TestItem(domain: "accounts")
        let details  = TestItem(domain: "accounts", path: "id")
        let dest     = TestItem(domain: "payments")

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

        XCTAssertRoutesEqual(nav.path, [auth, flow1, accounts, dest])
    }

    /// B) clearStack=true with NO boundary → stack unchanged, just appends.
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

    /// C) clearStack=true and top is a boundary → no trim (boundary kept), then append.
    func test_navigateTo_clearStack_whenTopIsBoundary_keepsTop_thenAppends() {
        let topBoundary = TestItem(domain: "auth")         // boundary at top
        let dest = TestItem(domain: "auth", path: "next")

        RouterLookup.find = { domain in
            TestFeatureRouter(domain: domain, hasBottomNavigation: domain == "auth")
        }

        let (sut, nav, _) = makeSUT(startPath: [topBoundary])

        sut.navigateTo(item: dest, clearStack: true)

        XCTAssertRoutesEqual(nav.path, [topBoundary, dest])
    }

    /// D) id bump occurs when trimming happens during clearStack.
    func test_navigateTo_clearStack_trimmingChangesNavigatorId() {
        let homeBoundary = TestItem(domain: "home")
        let inner        = TestItem(domain: "flow")        // non-boundary
        let dest         = TestItem(domain: "payments")

        RouterLookup.find = { domain in
            switch domain {
            case "home": return TestFeatureRouter(domain: domain, hasBottomNavigation: true)
            default:     return TestFeatureRouter(domain: domain, hasBottomNavigation: false)
            }
        }

        let (sut, nav, _) = makeSUT(startPath: [homeBoundary, inner])
        let oldId = nav.id

        sut.navigateTo(item: dest, clearStack: true)

        XCTAssertNotEqual(nav.id, oldId)
        XCTAssertRoutesEqual(nav.path, [homeBoundary, dest])
    }

    /// E) clearStack=false → never trims, regardless of boundaries.
    func test_navigateTo_withoutClearStack_justAppends() {
        let a = TestItem(domain: "accounts") // could be boundary
        let dest = TestItem(domain: "payments")

        RouterLookup.find = { domain in
            TestFeatureRouter(domain: domain, hasBottomNavigation: domain == "accounts")
        }

        let (sut, nav, _) = makeSUT(startPath: [a])

        sut.navigateTo(item: dest, clearStack: false)

        XCTAssertRoutesEqual(nav.path, [a, dest])
    }
}
