import Shared // your KMP shared module

extension NavigationItem {

    /// Stable unique key for navigation identity in SwiftUI
    var navKey: String {
        let domain = domain()
        let path = path()

        // Convert KMP maps to Swift dictionaries safely
        let pathParams = convertMapToDict(kmpMap: pathParams())
        let queryParams = convertMapToDict(kmpMap: queryParams())

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

    private func convertMapToDict(kmpMap: KotlinMap<AnyObject, AnyObject>?) -> [String: String] {
        var dict: [String: String] = [:]
        kmpMap?.forEach { key, value in
            if let k = key as? String {
                dict[k] = "\(value)"
            }
        }
        return dict
    }
}


extension NavigationItem: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(navKey)
    }

    public static func == (lhs: NavigationItem, rhs: NavigationItem) -> Bool {
        lhs.navKey == rhs.navKey
    }
}


@ViewBuilder
private func destination(_ item: NavigationItem) -> some View {
    makeScreen(selectedPath: item)
        .id(item.navKey)
        .onAppear {
            guard item == navigator.path.last else { return }
            // Only run side-effects for top item
        }
}


    .onChange(of: navigator.path) { path in
        print("NAV PATH:", path.map { $0.navKey })
    }
    .navigationDestination(for: NavigationItem.self) { item in
        print("DESTINATION BUILD:", item.navKey)
        destination(item)
    }
