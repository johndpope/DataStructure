
import CKit

public final class LinkedList<T> : Collection
{

    var _count = 0
    var _first: UnsafeMutablePointer<Node>?
    var _last: UnsafeMutablePointer<Node>?
    var _trashcan: UnsafeMutablePointer<Node>? // stack storing trash nodes

//    #if DEBUG
    var using_stack_allocated_nodes = false
//    #endif

    public init() {

    }

    public init(list: LinkedList<T>, from: Int, to: Int) {
        self._first = list._first
        self._count = to - from
    }

    deinit {

        if using_stack_allocated_nodes {
            return
        }
        var start = _first

        while start?.pointee._next != nil {
            if let _start_ = start {
                start = _start_.pointee._next
                _start_.deallocate(capacity: 1)
            }
        }

        while (_trashcan != nil) {
            var node: UnsafeMutablePointer<Node>?
            stack_pop(&_trashcan, &node)
            node?.deallocate(capacity: 1)
        }
    }
}

public extension LinkedList
{
    public func makeIterator() -> Node {
        return Node(mirror: _first)
    }

    public struct Node: IteratorProtocol, ForwardNode {

        public typealias Element = T

        var _next: UnsafeMutablePointer<Node>?
        var _pervious: UnsafeMutablePointer<Node>?

        public var storage: Element?

        public init(mirror: UnsafeMutablePointer<Node>?) {
            self._next = mirror
            self.storage = mirror?.pointee.storage
        }

        public init(storage: Element?) {
            self.storage = storage
        }

        public mutating func next() -> Element? {
    
            guard let _next_ = _next else {
                return nil
            }
            
            self = _next_.pointee
            return _next_.pointee.storage
        }
        
        static func dummy(linking: UnsafeMutablePointer<Node>) -> Node {
            return Node(mirror: linking)
        }

        static func pop(node: UnsafeMutablePointer<Node>)  {
            node.pointee._next?.pointee._pervious = node.pointee._pervious
            node.pointee._pervious?.pointee._next = node.pointee._next
        }

        static func push_front(target: UnsafeMutablePointer<Node>,
                                           _ node: UnsafeMutablePointer<Node>) {
            target.pointee._pervious?.pointee._next = node
            node.pointee._pervious = target.pointee._pervious
            target.pointee._pervious = node
            node.pointee._next = target
        }

        static func push_back(target: UnsafeMutablePointer<Node>,
                                          _ node: UnsafeMutablePointer<Node>) {
            node.pointee._next = target.pointee._next
            target.pointee._next?.pointee._pervious = node
            node.pointee._pervious = target
            target.pointee._next = node
        }
    }
}

public extension LinkedList {

    @inline(__always)
    func reserver_capacity(count: Int) {
        if count <= self.count {
            return
        }

        for _ in 0 ..< (count - self.count) {
            let nodep = make_new_node(element: nil)
            stack_push(&_trashcan, nodep)
        }
    }

    func list_is_empty() -> Bool {
        return _first == nil && _last == nil
    }

    @inline(__always)
    func init_list(with node: UnsafeMutablePointer<Node>) {
        node.pointee._next = nil
        node.pointee._pervious = nil
        _first = node
        _last = node
        _count = 1
    }

    @inline(__always)
    func test_drain() {
        if _last == nil || _first == nil {
            _first = nil
            _last = nil
        }
    }

    @inline(__always)
    func push_front(node: UnsafeMutablePointer<Node>) {
        if let _first_ = _first {
            if _last == _first_ {
                _first = node
            }
            Node.push_front(target: _first_, node)
            _count += 1
            return
        }

        // if the list is empty
        init_list(with: node)
    }

    @inline(__always)
    func push_back(node: UnsafeMutablePointer<Node>) {
        
        if let _last_ = _last {
            Node.push_back(target: _last_, node)
            _last = node
            _count += 1
            return
        }
        // if the list is empty
        init_list(with: node)
    }

    @inline(__always)
    func pop(_ node: UnsafeMutablePointer<Node>) {
        _count -= 1
        Node.pop(node: node)
        stack_push(&_trashcan, node)
        test_drain()
    }

    @inline(__always)
    func pop_back(_ output: inout T?) {
        // no item, what you expect
        guard let _last_ = _last else {
            output = nil
            return
        }
        
        output = _last_.pointee.storage
        _last = _last_.pointee._pervious
        pop(_last_)
    }

    @inline(__always)
    func pop_front(_ output: inout T?) {
        // no item, what you expect
        guard let _first_ = _first else {
            output = nil
            return
        }

        output = _first_.pointee.storage
        _first = _first_.pointee._next
        pop(_first_)
    }

    @inline(__always)
    func make_new_node(element: T?) -> UnsafeMutablePointer<Node> {
        let nodep = UnsafeMutablePointer<Node>.allocate(capacity: 1)
        var node = Node(storage: element)
        memcpy(nodep.mutableRawPointer, mutablePointer(of: &node).rawPointer, MemoryLayout<Node>.size)
        print("allocated")
        return nodep
    }
    
    @inline(__always)
    func request_node(with value: T) -> UnsafeMutablePointer<Node> {
        var nodep: UnsafeMutablePointer<Node>?
        if !attempt_recycle_node(to: &nodep) {
            nodep = make_new_node(element: value)
        } else {
            nodep!.pointee.storage = value
        }
        return nodep!
    }
    
    @inline(__always)
    func attempt_recycle_node(to output: inout UnsafeMutablePointer<Node>?) -> Bool {
        
        stack_pop(&self._trashcan, &output)

        if output == nil {
            return false
        }
        
        output!.pointee._next = nil
        output!.pointee._pervious = nil
        output!.pointee.storage = nil
        
        return true
    }
    
    @inline(__always)
    func iterator_pointer(at index: Int) -> UnsafeMutablePointer<Node>? {
        guard let first = self._first,
                index < count else {
                    print("index < count")
            return nil
        }
        
        print(first.pointee)
        
        var it = first
        
        for _ in 0..<index {
            it = it.pointee._next!
        }
        
        print(it)
        return it
    }
}

public extension LinkedList {
    
    public func append(_ item: T) {
        self.push_back(node: request_node(with: item))
    }
    
    public func insert(_ newElement: T, at index: Int) {
        
        assert(index < self.count)
    
        if index == 0 {
            return self.push_front(node: request_node(with: newElement))
        }
        
        if index + 1 == self.count {
            return append(newElement)
        }
        
        self.push_back(node: iterator_pointer(at: index - 1)!)
    }

    public func reserveCapacity(count: Int) {
        reserver_capacity(count: count)
    }

    public func popFirst() -> T? {
        var ret: T?
        pop_front(&ret)
        return ret
    }

    public func removeLast() -> T? {
        var ret: T?
        pop_back(&ret)
        return ret
    }
}

public extension LinkedList {
    public var isEmpty: Bool {
        return _count == 0
    }

    public var count: Int {
        return _count
    }

    public var underestimatedCount: Int {
        return _count
    }

    public var first: T? {
        return _first?.pointee.storage
    }
}

public extension LinkedList {

    public typealias Index = Int

    public var startIndex: Int {
        return 0
    }

    public var endIndex: Int {
        return self.count - 1
    }

    public func index(after i: Int) -> Int {
        return i + 1
    }
    
    public subscript(_ range: Range<Int>) -> LinkedList<T> {
        return LinkedList<T>()
    }

    public subscript(position: Int) -> Node.Element {
        let it = iterator_pointer(at: position)
        return it!.pointee.storage!
    }
}
