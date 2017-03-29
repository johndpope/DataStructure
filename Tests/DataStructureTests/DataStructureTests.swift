import XCTest
import CKit
import Foundation
import Dispatch

@testable import DataStructure

//extension timespec : CustomStringConvertible {
//    public var description: String {
//        return "sec: \(self.tv_sec) ns: \(self.tv_nsec)"
//    }
//}

class DataStructureTests: XCTestCase {
    
//    func time(block: () -> ()) -> timespec {
//        let now = timespec.now()
//        block()
//        let x = timespec.now() - now
//        print(x)
//        return x
//    }
//    
//    func testNodeInit() {
//        let node = LinkedList<Int>.Iterator(storage: 100)
//        XCTAssertEqual(node.storage, 100)
//    }
//    
//    typealias ckevent = Darwin.kevent
//    
//    struct Foo {
//        var d: Int = 10
//        
//        init() {
//            
//        }
//    }
//    
//    func testAppend() {
//        let list = LinkedList<Int>()
//        for i in 0..<5 {
//            list.append(i)
//        }
//    
//        XCTAssertEqual(list[0], 0)
//        XCTAssertEqual(list[1], 1)
//        XCTAssertEqual(list[2], 2)
//        XCTAssertEqual(list[3], 3)
//        XCTAssertEqual(list[4], 4)
//    }

//    func testInitList() {
//        var node = LinkedList<Int>.Iterator(storage: 99)
//        let list = LinkedList<Int>()
//        list.using_stack_allocated_nodes = true
//        list.init_list(with: mutablePointer(of: &node))
//        XCTAssertEqual(99, list._first?.pointee.storage)
//        XCTAssertEqual(99, list._last?.pointee.storage)
//    }
    
//    func test_push_back() {
//        var node = LinkedList<Int>.Iterator(storage: 99)
//        let list = LinkedList<Int>()
//        list.using_stack_allocated_nodes = true
//        list.push_back(node: mutablePointer(of: &node))
//        XCTAssertEqual(99, list._first?.pointee.storage)
//    }
    
//    func test_iterator() {
//        let list = LinkedList<Int>()
//        
//        list.append(99)
//        list.append(90)
//        list.append(85)
//        list.append(80)
//        
//        for (index, item) in list.enumerated() {
//            XCTAssertEqual(list[index], item)
//            print(item)
//        }
//    }
//    
//    
    func test_push_and_pop() {
        var list = LinkedList<Int>()
        XCTAssertEqual(list._count, 0)
        
        list.append(99)
        list.append(90)
        list.append(85)
        list.append(80)
        
        print("NO MORE ALLOCATION SHOULD OCCUR AT THIS POINT")
        XCTAssertEqual(99, list[0])
        XCTAssertEqual(90, list[1])
        XCTAssertEqual(85, list[2])
        XCTAssertEqual(80, list[3])
        
        XCTAssertEqual(list._count, 4)
        XCTAssertEqual(80, list.removeLast())
        XCTAssertEqual(85, list.removeLast())
        XCTAssertEqual(90, list.removeLast())
        XCTAssertEqual(99, list.removeLast())
        
        list.append(99)
        list.append(90)
        list.append(85)
        list.append(80)
   
        print("poping")
        XCTAssertEqual(99, list.popFirst())
        XCTAssertEqual(90, list.popFirst())
        XCTAssertEqual(85, list.popFirst())
        XCTAssertEqual(80, list.popFirst())
        
        list.append(99)
        list.append(90)
        list.append(85)
        list.append(80)
        
        print("CHECKPOINT")

        XCTAssertEqual(99, list[0])
        XCTAssertEqual(90, list[1])
        XCTAssertEqual(85, list[2])
        XCTAssertEqual(80, list[3])
        
        for item in list {
            print(item)
        }
        
    }
//    
    func test_stack() {
        let stack = Stack<Int>()
        stack.push(item: 1)
        stack.push(item: 2)
        stack.push(item: 3)
        stack.push(item: 4)
        stack.push(item: 5)
    
        XCTAssertTrue(stack.contains(5))
        
        XCTAssertEqual(stack.popFirst(), 5)
        XCTAssertEqual(stack.popFirst(), 4)
        XCTAssertEqual(stack.popFirst(), 3)
        XCTAssertEqual(stack.popFirst(), 2)
        XCTAssertEqual(stack.popFirst(), 1)
    }
//
//    func test_push_back2() {
//        var node = LinkedList<Int>.Iterator(storage: 99)
//        var node1 = LinkedList<Int>.Iterator(storage: 90)
//        var node2 = LinkedList<Int>.Iterator(storage: 85)
//        var node3 = LinkedList<Int>.Iterator(storage: 80)
//        let list = LinkedList<Int>()
//        list.using_stack_allocated_nodes = true
//        list.push_back(node: mutablePointer(of: &node))
//        list.push_back(node: mutablePointer(of: &node1))
//        list.push_back(node: mutablePointer(of: &node2))
//        list.push_back(node: mutablePointer(of: &node3))
//        XCTAssertEqual(99, list._first?.pointee.storage)
//        XCTAssertEqual(99, list[0])
//        XCTAssertEqual(90, list[1])
//        XCTAssertEqual(85, list[2])
//        XCTAssertEqual(80, list[3])
//    }
//    
//    func test_pop_back2() {
//        var node = LinkedList<Int>.Iterator(storage: 99)
//        var node1 = LinkedList<Int>.Iterator(storage: 90)
//        var node2 = LinkedList<Int>.Iterator(storage: 85)
//        var node3 = LinkedList<Int>.Iterator(storage: 80)
//        let list = LinkedList<Int>()
//        list.using_stack_allocated_nodes = true
//        list.push_back(node: mutablePointer(of: &node))
//        list.push_back(node: mutablePointer(of: &node1))
//        list.push_back(node: mutablePointer(of: &node2))
//        list.push_back(node: mutablePointer(of: &node3))
//        XCTAssertEqual(99, list._first?.pointee.storage)
//        XCTAssertEqual(99, list[0])
//        XCTAssertEqual(90, list[1])
//        XCTAssertEqual(85, list[2])
//        XCTAssertEqual(80, list[3])
//        
//        var out: Int? = 0
//        list.pop_back(&out)
//        XCTAssertEqual(80, out)
//        list.pop_back(&out)
//        XCTAssertEqual(85, out)
//        list.pop_back(&out)
//        XCTAssertEqual(90, out)
//        list.pop_back(&out)
//        XCTAssertEqual(99, out)
//        list.pop_back(&out)
//        XCTAssertEqual(nil, out)
//    }
//
////    func test_reserve_capacity() {
////        let list = LinkedList<Int>()
////        list.reserveCapacity(count: 4)
////        print("should not malloc beyound this point")
////        sleep(3)
////        list.append(99)
////        list.append(90)
////        list.append(85)
////        list.append(80)
////    }
////
//    func test_append() {
//        let list = LinkedList<Int>()
//        list.append(99)
//        list.append(90)
//        list.append(85)
//        list.append(80)
//        XCTAssertEqual(99, list[0])
//        XCTAssertEqual(90, list[1])
//        XCTAssertEqual(85, list[2])
//        XCTAssertEqual(80, list[3])
//        
//    }
//    
//    func testRemoveFirst() {
//        let list = LinkedList<Int>()
//        list.append(99)
//        list.append(90)
//        list.append(85)
//        list.append(80)
//        
//        XCTAssertEqual(99, list.removeFirst())
//        XCTAssertEqual(90, list.removeFirst())
//        XCTAssertEqual(85, list.removeFirst())
//        XCTAssertEqual(80, list.removeFirst())
//    }
//
//    func testSubscript() {
//        var node = LinkedList<Int>.Iterator(storage: 99)
//        let list = LinkedList<Int>()
//        list.init_list(with: mutablePointer(of: &node))
//        XCTAssertEqual(99, list[0])
//    }

    static var allTests : [(String, (DataStructureTests) -> () throws -> Void)] {
        return [
            
        ]
    }
}
