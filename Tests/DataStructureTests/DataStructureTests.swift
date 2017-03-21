import XCTest
@testable import DataStructure

class DataStructureTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(DataStructure().text, "Hello, World!")
    }


    static var allTests : [(String, (DataStructureTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
