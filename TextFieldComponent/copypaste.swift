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
