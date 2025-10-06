import Shared // your KMP shared module

extension NavigationItem {

    /// Stable unique key for navigation identity in SwiftUI
    var navKey: String {
        let domain = domain()
        let path = path()

        // Convert KMP maps to Swift dictionaries safely
        let pathParams = convertMapToDict(anyMap: pathParams())
        let queryParams = convertMapToDict(anyMap: queryParams())

        // Serialize params in sorted order for stability
        let serializedPathParams = pathParams
            .sorted(by: { $0.key < $1.key })
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")

        let serializedQueryParams = queryParams
            .sorted(by: { $0.key < $1.key })
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")

        return "\(domain)|\(path)|\(serializedPathParams)|\(serializedQueryParams)"
    }

    /// Converts a KMP Map<*, *> (bridged to NSDictionary) to [String: String]
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
}

// MARK: - Hashable Support
extension NavigationItem: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(navKey)
    }

    public static func == (lhs: NavigationItem, rhs: NavigationItem) -> Bool {
        lhs.navKey == rhs.navKey
    }
}
