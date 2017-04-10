
import XCTest
@testable import DataStructure

extension DataStructureTests {

    func test_queue() {
        var queue = Queue<Int>()

        queue.enqueue(item: 1)
        queue.enqueue(item: 2)
        queue.enqueue(item: 3)
        queue.enqueue(item: 4)
        queue.enqueue(item: 5) 
        queue.enqueue(item: 6)

        XCTAssertEqual(1, queue.dequeue())
        XCTAssertEqual(2, queue.dequeue())
        XCTAssertEqual(3, queue.dequeue())
        XCTAssertEqual(4, queue.dequeue())
        XCTAssertEqual(5, queue.dequeue())
        XCTAssertEqual(6, queue.dequeue())
        
    }
}
