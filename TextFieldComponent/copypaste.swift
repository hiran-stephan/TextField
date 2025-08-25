import Foundation
@testable import iosApp

final class TestItem: NavigationItem, Equatable {
    let key: String
    private let d: String
    private let p: String

    init(key: String, domain: String, path: String = "") {
        self.key = key
        self.d = domain
        self.p = path
        super.init()
    }

    // Only override what’s abstract/required.
    // Do NOT override route() or matches(...).
    override func domain() -> String { d }
    override func path()   -> String { p }

    // For XCTAssertEqual in tests
    static func == (lhs: TestItem, rhs: TestItem) -> Bool {
        lhs.key == rhs.key && lhs.d == rhs.d && lhs.p == rhs.p
    }
}
