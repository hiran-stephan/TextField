extension NavigationItem {

    // MARK: Stable key for SwiftUI identity
    var navKey: String {
        let domain = domain()
        let path = path()

        // Convert KMP maps (NSDictionary bridge)
        let pathParams = convertMapToDict(anyMap: pathParams())
        let queryParams = convertMapToDict(anyMap: queryParams())

        // Sort for deterministic key
        let serializedPathParams = pathParams
            .sorted { $0.key < $1.key }
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")

        let serializedQueryParams = queryParams
            .sorted { $0.key < $1.key }
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")

        return "\(domain)|\(path)|\(serializedPathParams)|\(serializedQueryParams)"
    }

    /// Converts KMP Map<*, *> (bridged as NSDictionary) to Swift [String:String]
    private func convertMapToDict(anyMap: Any?) -> [String: String] {
        guard let dict = anyMap as? NSDictionary else { return [:] }
        var result: [String: String] = [:]
        for (key, value) in dict {
            if let k = key as? String {
                result[k] = "\(value)"
            }
        }
        return result
    }

    // MARK: NSObject overrides for equality & hash

    public override var hash: Int {
        navKey.hashValue
    }

    public override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? NavigationItem else { return false }
        return self.navKey == other.navKey
    }

    // MARK: Optional Swift convenience (not override)
    public func hash(into hasher: inout Hasher) {
        hasher.combine(navKey)
    }

    public static func == (lhs: NavigationItem, rhs: NavigationItem) -> Bool {
        lhs.navKey == rhs.navKey
    }
}
