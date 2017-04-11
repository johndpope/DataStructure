
import  XCTest
@testable import DataStructure

extension DataStructureTests {
    func test_min_heap() {
        var heap = MinHeap<Int>(capacity: 100)
        
        heap.push(item: 5)
        heap.push(item: 14)
        heap.push(item: 10)
        heap.push(item: 9)
        heap.push(item: 3)
        heap.push(item: 1)
        heap.push(item: 2)
        
        XCTAssertEqual(heap.pop(), 1)
        XCTAssertEqual(heap.pop(), 2)
        XCTAssertEqual(heap.pop(), 3)
        XCTAssertEqual(heap.pop(), 5)
        XCTAssertEqual(heap.pop(), 9)
        XCTAssertEqual(heap.pop(), 10)
        XCTAssertEqual(heap.pop(), 14)
    }
    
    func test_min_heap_init_with_array() {
        var heap = MinHeap<Int>([5, 14, 10, 9, 3, 1, 2])

        XCTAssertEqual(heap.pop(), 1)
        XCTAssertEqual(heap.pop(), 2)
        XCTAssertEqual(heap.pop(), 3)
        XCTAssertEqual(heap.pop(), 5)
        XCTAssertEqual(heap.pop(), 9)
        XCTAssertEqual(heap.pop(), 10)
        XCTAssertEqual(heap.pop(), 14)
    }
   
    func test_max_heap() {
        var heap = MaxHeap<Int>(capacity: 100)
        
        heap.push(item: 5)
        heap.push(item: 14)
        heap.push(item: 10)
        heap.push(item: 9)
        heap.push(item: 3)
        heap.push(item: 1)
        heap.push(item: 2)

        XCTAssertEqual(heap.pop(), 14)
        XCTAssertEqual(heap.pop(), 10)
        XCTAssertEqual(heap.pop(), 9)
        XCTAssertEqual(heap.pop(), 5)
        XCTAssertEqual(heap.pop(), 3)
        XCTAssertEqual(heap.pop(), 2)
        XCTAssertEqual(heap.pop(), 1)
    }
    
    func test_max_heap_init_with_array() {
        var heap = MaxHeap<Int>([5, 14, 10, 9, 3, 1, 2])
        
        XCTAssertEqual(heap.pop(), 14)
        XCTAssertEqual(heap.pop(), 10)
        XCTAssertEqual(heap.pop(), 9)
        XCTAssertEqual(heap.pop(), 5)
        XCTAssertEqual(heap.pop(), 3)
        XCTAssertEqual(heap.pop(), 2)
        XCTAssertEqual(heap.pop(), 1)
    }
}
