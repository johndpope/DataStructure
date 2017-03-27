import XCTest
import CKit

@testable import DataStructure

extension timespec : CustomStringConvertible {
    public var description: String {
        return "sec: \(self.tv_sec) ns: \(self.tv_nsec)"
    }
}

class DataStructureTests: XCTestCase {
    
    func time(block: () -> ()) -> timespec {
        let now = timespec.now()
        block()
        let x = timespec.now() - now
        print(x)
        return x
    }
    
    func testNodeInit() {
        let node = ListNode<Int>(storage: 100)
        XCTAssertEqual(node.storage, 100)
    }
    
    func testAppend() {
        var list = LinkedList<Int>()
        for i in 0..<5 {
            list.append(i)
        }
    
        XCTAssertEqual(list[0], 0)
        XCTAssertEqual(list[1], 1)
        XCTAssertEqual(list[2], 2)
        XCTAssertEqual(list[3], 3)
        XCTAssertEqual(list[4], 4)
    }

    func testInitList() {
        var node = ListNode<Int>(storage: 99)
        var list = LinkedList<Int>()
        list.init_list(with: mutablePointer(of: &node))
        XCTAssertEqual(99, list._first?.pointee.storage)
        XCTAssertEqual(99, list._last?.pointee.storage)
    }
    
    func test_push_back() {
        var node = ListNode<Int>(storage: 99)
        var list = LinkedList<Int>()
        list.push_back(node: mutablePointer(of: &node))
        XCTAssertEqual(99, list._first?.pointee.storage)
    }
    
    func test_push_back2() {
        var node = ListNode<Int>(storage: 99)
        var node1 = ListNode<Int>(storage: 90)
        var node2 = ListNode<Int>(storage: 85)
        var node3 = ListNode<Int>(storage: 80)
        var list = LinkedList<Int>()
        list.push_back(node: mutablePointer(of: &node))
        list.push_back(node: mutablePointer(of: &node1))
        list.push_back(node: mutablePointer(of: &node2))
        list.push_back(node: mutablePointer(of: &node3))
        XCTAssertEqual(99, list._first?.pointee.storage)
        XCTAssertEqual(99, list[0])
        XCTAssertEqual(90, list[1])
        XCTAssertEqual(85, list[2])
        XCTAssertEqual(80, list[3])
    }
    
    func test_append() {
        var list = LinkedList<Int>()
        list.append(99)
        list.append(90)
        list.append(85)
        list.append(80)
        XCTAssertEqual(99, list[0])
        XCTAssertEqual(90, list[1])
        XCTAssertEqual(85, list[2])
        XCTAssertEqual(80, list[3])
        
    }
    
    func testSubscript() {
        var node = ListNode<Int>(storage: 99)
        var list = LinkedList<Int>()
        list.init_list(with: mutablePointer(of: &node))
        XCTAssertEqual(99, list[0])
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        XCTAssertEqual(DataStructure().text, "Hello, World!")
//        let size = 64
//        var timevec = [timespec]()
//        for _ in 0..<Int(2000) {
//            
//            timevec.append(time {
//                _ = malloc(size)
//            })
//        }
//        
//        print(timevec)
    }


    static var allTests : [(String, (DataStructureTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
