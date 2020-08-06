import XCTest
@testable import Rebine

final class RebineTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Rebine().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
