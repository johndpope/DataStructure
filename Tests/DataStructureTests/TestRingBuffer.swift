
import XCTest
@testable import DataStructure

extension DataStructureTests {
    
    func teste_ring_buffer_iterator() {
        var buffer = RingBuffer<Int>(capacity: 5)
        buffer.enqueue(item: 0)
        buffer.enqueue(item: 1)
        buffer.enqueue(item: 2)
        buffer.enqueue(item: 3)
        buffer.enqueue(item: 4)
        
        for i in buffer {
            print(i)
        }
    }

    func test_ring_buffer_get_correct_val() {
        var buffer = RingBuffer<Int>(capacity: 5)
        buffer.enqueue(item: 0)
        buffer.enqueue(item: 1)
        buffer.enqueue(item: 2)
        buffer.enqueue(item: 3)
        buffer.enqueue(item: 4)
        print("\n\n====\(buffer.storage)===\n\n")
        XCTAssertEqual(0, buffer[0])
        XCTAssertEqual(1, buffer[1])
        XCTAssertEqual(2, buffer[2])
        XCTAssertEqual(3, buffer[3])
        XCTAssertEqual(4, buffer[4])

        buffer.dequeue()
        buffer.dequeue()

        XCTAssertEqual(3, buffer.count)
        print("begin enqueue \(buffer.readIndex)")
        buffer.enqueue(item: 5)
        buffer.enqueue(item: 6)
        print("finished enqueue \(buffer.storage)")
        XCTAssertEqual(5, buffer.count)
        
        for i in buffer {
            print(i)
        }

        XCTAssertEqual(5, buffer[3])
        XCTAssertEqual(6, buffer[4])
    }

    func test_ring_buffer_empty_full() {
        var buffer = RingBuffer<Int>(capacity: 5)
        buffer.enqueue(item: 0)
        buffer.enqueue(item: 1)
        buffer.enqueue(item: 2)
        buffer.enqueue(item: 3)
        buffer.enqueue(item: 4)

        XCTAssertEqual(buffer.isFull, true)

        buffer.dequeue()
        buffer.dequeue()
        buffer.dequeue()
        buffer.dequeue()
        buffer.dequeue()

        XCTAssertEqual(buffer.isEmpty, true)

        buffer.enqueue(item: 0)
        buffer.enqueue(item: 1)
        buffer.enqueue(item: 2)
        buffer.enqueue(item: 3)
        buffer.enqueue(item: 4)

        XCTAssertEqual(buffer.isFull, true)

        buffer.dequeue()
        buffer.dequeue()
        buffer.dequeue()
        buffer.dequeue()
        buffer.dequeue()

        XCTAssertEqual(buffer.isEmpty, true)
        
        buffer.enqueue(item: 0)
        buffer.enqueue(item: 1)
        buffer.enqueue(item: 2)
        buffer.enqueue(item: 3)
        buffer.enqueue(item: 4)

        XCTAssertEqual(buffer.isFull, true)

        buffer.dequeue()
        buffer.dequeue()
        buffer.dequeue()
        buffer.dequeue()
        buffer.dequeue()

        XCTAssertEqual(buffer.isEmpty, true)

        buffer.enqueue(item: 0)
        buffer.enqueue(item: 1)
        buffer.enqueue(item: 2)
        buffer.enqueue(item: 3)
        buffer.enqueue(item: 4)

        XCTAssertEqual(buffer.isFull, true)
    }
}
