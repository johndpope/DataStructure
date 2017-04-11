
import XCTest
@testable import DataStructure

extension DataStructureTests {
    
    func test_bip_buffer_as_pointer() {
        var buffer = BipBuffer<Int>(capacity: 5)
        
        buffer.enqueue(item: 0)
        buffer.enqueue(item: 1)
        buffer.enqueue(item: 2)
        buffer.enqueue(item: 3)
        buffer.enqueue(item: 4)

        _ = buffer.withUnsafeMutablePointer(startIndex: 2) {
            XCTAssertEqual(2, $0.advanced(by: 0).pointee)
            XCTAssertEqual(3, $0.advanced(by: 1).pointee)
            XCTAssertEqual(4, $0.advanced(by: 2).pointee)
            XCTAssertEqual(0, $0.advanced(by: 3).pointee)
            XCTAssertEqual(1, $0.advanced(by: 4).pointee)
        }
    }

    func test_bip_buffer_get_correct_val() {
        var buffer = BipBuffer<Int>(capacity: 5)

        buffer.enqueue(item: 0)
        buffer.enqueue(item: 1)
        buffer.enqueue(item: 2)
        buffer.enqueue(item: 3)
        buffer.enqueue(item: 4)

        XCTAssertEqual(0, buffer[0])
        XCTAssertEqual(1, buffer[1])
        XCTAssertEqual(2, buffer[2])
        XCTAssertEqual(3, buffer[3])
        XCTAssertEqual(4, buffer[4])
        
        buffer.dequeue()
        buffer.dequeue()
        
        XCTAssertEqual(3, buffer.count)
        
        buffer.enqueue(item: 5)
        buffer.enqueue(item: 6)
        
        XCTAssertEqual(5, buffer.count)
        
        for (index, val) in buffer.enumerated() {
            switch index {
            case 0:
                XCTAssertEqual(val, 0)
            case 1:
                XCTAssertEqual(val, 1)
            case 2:
                XCTAssertEqual(val, 3)
            case 3:
                XCTAssertEqual(val, 5)
            case 4:
                XCTAssertEqual(val, 6)
            default:
                break
            }
        }
    }
    
    func test_bip_buffer_empty_full() {
        var buffer = BipBuffer<Int>(capacity: 5)
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
        
        XCTAssertEqual(buffer.isEmpty, false)
        
        buffer.dequeue()
        
        XCTAssertEqual(buffer.isEmpty, true)
        XCTAssertEqual(buffer.isFull, false)
        
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
    }}
