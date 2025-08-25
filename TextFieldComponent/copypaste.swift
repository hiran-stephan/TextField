let authDomain      = NavigationItems.shared.authentication.DOMAIN
    let authSignOn      = NavigationItems.shared.authentication.DOMAIN_SIGNON

    RouterLookup.find = { domain in
        switch domain {
        // mark BOTH auth domains as bottom-nav boundaries
        case authDomain, authSignOn:
            return TestFeatureRouter(domain: domain, hasBottomNavigation: true)

        // accounts is also a boundary in your flows
        case "accounts":
            return TestFeatureRouter(domain: domain, hasBottomNavigation: true)

        // everything else is non-boundary
        default:
            return TestFeatureRouter(domain: domain, hasBottomNavigation: false)
        }
    }

@MainActor
func test_navigateTo_clearStack_trimsToLastBoundary_thenAppends() {
    let auth      = TestItem(domain: NavigationItems.shared.authentication.DOMAIN)
    let flow1     = TestItem(domain: "flow")
    let accounts  = TestItem(domain: "accounts")
    let details   = TestItem(domain: "accounts", path: ":id")
    let dest      = TestItem(domain: "payments", path: ":1")

    let (sut, nav, _) = makeSUT(startPath: [auth, flow1, accounts, details])

    sut.navigateTo(item: dest, clearStack: true)

    // Keeps up to LAST boundary ("accounts"), then appends dest
    XCTAssertRoutesEqual(nav.path, [auth, flow1, accounts, dest])
}

