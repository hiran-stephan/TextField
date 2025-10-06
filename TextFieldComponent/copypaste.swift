// MARK: - Stable Hash & Equality for SwiftUI Navigation
extension NavigationItem {

    // Override NSObject hash for identity stability
    public override var hash: Int {
        navKey.hashValue
    }

    // Override NSObject equality
    public override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? NavigationItem else { return false }
        return self.navKey == other.navKey
    }

    // Optional: convenience for SwiftUI Hashable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(navKey)
    }

    public static func == (lhs: NavigationItem, rhs: NavigationItem) -> Bool {
        lhs.navKey == rhs.navKey
    }
}
