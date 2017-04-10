
@testable import DataStructure

extension DataStructureTests {
    func test_class_list() {
        let list = LinkedList<SharedTestRefType>()
        
        list.append(SharedTestRefType(0))
        list.append(SharedTestRefType(1))
        list.append(SharedTestRefType(2))
        list.append(SharedTestRefType(3))
        print("END POINT")
        
        let _0 = list.popFirst()
        let _1 = list.popFirst()
        let _2 = list.popFirst()
        let _3 = list.popFirst()
        
        XCTAssertEqual(_0?.i, 0)
        XCTAssertEqual(_1?.i, 1)
        XCTAssertEqual(_2?.i, 2)
        XCTAssertEqual(_3?.i, 3)
        
        print("Clean up")
    }
    

    
    func test_push_back() {
        var node = LinkedList<Int>.Iterator(item: 99)
        let list = LinkedList<Int>()
        list.push_back(node: mutablePointer(of: &node))
        XCTAssertEqual(99, list._entry?.pointee.item)
    }
    
    func test_iterator() {
        let list = LinkedList<Int>()
        
        list.append(99)
        list.append(90)
        list.append(85)
        list.append(80)
        
        for (index, item) in list.enumerated() {
            XCTAssertEqual(list[index], item)
            print(item)
        }
    }

    func test_push_and_pop() {
        let list = LinkedList<Int>()
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

        XCTAssertEqual(99, list.popFirst())
        XCTAssertEqual(90, list.popFirst())
        XCTAssertEqual(85, list.popFirst())
        XCTAssertEqual(80, list.popFirst())

        list.append(99)
        list.append(90)
        list.append(85)
        list.append(80)


        XCTAssertEqual(99, list[0])
        XCTAssertEqual(90, list[1])
        XCTAssertEqual(85, list[2])
        XCTAssertEqual(80, list[3])

        for (index, item) in list.enumerated() {
            print("\(index): \(item)")
        }

        let i = list.remove(at: 2)
        XCTAssertEqual(i, 85)

        for (index, item) in list.enumerated() {
            print("\(index): \(item)")
        }

    }

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

    func test_push_back2() {
        var node = LinkedList<Int>.Iterator(item: 99)
        var node1 = LinkedList<Int>.Iterator(item: 90)
        var node2 = LinkedList<Int>.Iterator(item: 85)
        var node3 = LinkedList<Int>.Iterator(item: 80)
        let list = LinkedList<Int>()
        list.using_stack_allocated_nodes = true
        list.push_back(node: mutablePointer(of: &node))
        list.push_back(node: mutablePointer(of: &node1))
        list.push_back(node: mutablePointer(of: &node2))
        list.push_back(node: mutablePointer(of: &node3))
        XCTAssertEqual(99, list._entry?.pointee.item)
        XCTAssertEqual(99, list[0])
        XCTAssertEqual(90, list[1])
        XCTAssertEqual(85, list[2])
        XCTAssertEqual(80, list[3])
    }

    func test_list_pop_back2() {
        var node = LinkedList<Int>.Iterator(item: 99)
        var node1 = LinkedList<Int>.Iterator(item: 90)
        var node2 = LinkedList<Int>.Iterator(item: 85)
        var node3 = LinkedList<Int>.Iterator(item: 80)
        let list = LinkedList<Int>()

        list.push_back(node: mutablePointer(of: &node))
        list.push_back(node: mutablePointer(of: &node1))
        list.push_back(node: mutablePointer(of: &node2))
        list.push_back(node: mutablePointer(of: &node3))

        XCTAssertEqual(99, list._entry?.pointee.item)
        XCTAssertEqual(99, list[0])
        XCTAssertEqual(90, list[1])
        XCTAssertEqual(85, list[2])
        XCTAssertEqual(80, list[3])

        XCTAssertEqual(80, list.removeLast())
        XCTAssertEqual(85, list.removeLast())
        XCTAssertEqual(90, list.removeLast())
        XCTAssertEqual(99, list.removeLast())
        XCTAssertEqual(nil, list.removeLast())
    }

    func test_list_reserve_capacity() {
        let list = LinkedList<Int>()
        list.reserveCapacity(count: 4)
        print("should not malloc beyound this point")
        sleep(3)
        list.append(99)
        list.append(90)
        list.append(85)
        list.append(80)
    }

    func test_list_append() {
        let list = LinkedList<Int>()
        list.append(99)
        list.append(90)
        list.append(85)
        list.append(80)
        XCTAssertEqual(99, list[0])
        XCTAssertEqual(90, list[1])
        XCTAssertEqual(85, list[2])
        XCTAssertEqual(80, list[3])

    }

    func test_list_remove_first() {
        let list = LinkedList<Int>()
        list.append(99)
        list.append(90)
        list.append(85)
        list.append(80)
        
        XCTAssertEqual(99, list.removeFirst())
        XCTAssertEqual(90, list.removeFirst())
        XCTAssertEqual(85, list.removeFirst())
        XCTAssertEqual(80, list.removeFirst())
    }

    func testSubscript() {
        var node = LinkedList<Int>.Iterator(item: 99)
        let list = LinkedList<Int>()
        list.entry_reconfig(with: mutablePointer(of: &node))
        XCTAssertEqual(99, list[0])
    }
}
