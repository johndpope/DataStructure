
@_exported import CKit
import Foundation
import Dispatch

@_exported import XCTest
@testable import DataStructure

func printSeparator() {
    print("\n\n")
}

class DataStructureTests: XCTestCase {
    
    func test_abs_mod() {
        XCTAssertEqual(4, -6 |%| 5)
    }
    
    static var allTests : [(String, (DataStructureTests) -> () throws -> Void)] {
        return [
            ("test_full", test_bip_buffer_empty_full),
            ("test_val", test_bip_buffer_get_correct_val)
        ]
    }
}
