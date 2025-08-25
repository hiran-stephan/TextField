final class TestFeatureRouter: FeatureRouter {
    let domain: String
    let hasBottomNavigation: Bool

    init(domain: String, hasBottomNavigation: Bool) {
        self.domain = domain
        self.hasBottomNavigation = hasBottomNavigation
    }

    // If FeatureRouter requires other members (like `parent`, `navigator`, etc.),
    // you can stub them minimally:
    var parent: ApplicationRouter { fatalError("unused in tests") }
    var navigator: FeatureNavigator? { nil }
    var requiresAuth: Bool { false }

    // If Kotlin adds more defaults, you can hardcode them or fatalError for now.
}

private var savedFind: ((String) -> FeatureRouter?)!


override func setUp() {
    super.setUp()
    savedFind = RouterLookup.find
    RouterLookup.find = { domain in
        switch domain {
        case "auth":     return TestFeatureRouter(domain: "auth", hasBottomNavigation: true)
        case "accounts": return TestFeatureRouter(domain: "accounts", hasBottomNavigation: true)
        case "flow":     return TestFeatureRouter(domain: "flow", hasBottomNavigation: false)
        case "payments": return TestFeatureRouter(domain: "payments", hasBottomNavigation: false)
        default:         return nil
        }
    }
}

override func tearDown() {
    RouterLookup.find = savedFind
    super.tearDown()
}
