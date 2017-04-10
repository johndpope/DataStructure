
import CKit

public final class LinkedList<T> : Collection
{

    public typealias NodeRef = UnsafeMutablePointer<Node>
    
    public var allocator: Allocator = SwiftAllocator()
    
    // to not conflict with the (immutable) count of collection
    var _count = 0
    
    var _capacity = 0
    
    // The entry node to the linked list data structure
    var _entry: NodeRef?
    
    // The end node of the linked list.
    var _last: NodeRef?
    
    // A stack that contains reuseable nodes
    var _trashcan: NodeRef? // stack storing trash nodes
    
    var _cleanup_stack = [() -> ()]()
    
    // for debug only
    var using_stack_allocated_nodes = false

    public init() {
    }

    deinit {
        _cleanup_stack.forEach{$0()}
    }
}

public extension LinkedList
{
    public func makeIterator() -> Node {
        return Node(mirror: _entry)
    }

    public struct Node: IteratorProtocol, ForwardNode, BackwardNode {

        public typealias Element = T

        var _next: NodeRef?
        var _pervious: NodeRef?

        public var item: Element?

        public init(mirror: NodeRef?) 
        {
            self._next = mirror
            self.item = mirror?.pointee.item
        }

        public init(item: Element?) {
            self.item = item
        }

        public mutating func next() -> Element? 
        {
            guard let _next_ = _next else {
                return nil
            }
            
            self = _next_.pointee
            return _next_.pointee.item
        }

        static func pop(node: NodeRef)  
        {
            node.pointee._next?.pointee._pervious = node.pointee._pervious
            node.pointee._pervious?.pointee._next = node.pointee._next
        }

        static func push_front(target: NodeRef,
                               _ node: NodeRef) 
        {
            target.pointee._pervious?.pointee._next = node
            node.pointee._pervious = target.pointee._pervious
            target.pointee._pervious = node
            node.pointee._next = target
        }

        static func push_back(target: NodeRef,
                              _ node: NodeRef) 
        {
            node.pointee._next = target.pointee._next
            target.pointee._next?.pointee._pervious = node
            node.pointee._pervious = target
            target.pointee._next = node
        }
    }
}

public extension LinkedList {

    /// This function turns an empty list to a list contains 1 item
    ///
    /// - Parameter node: The new first node (and also as the last node)
    @inline(__always)
    func entry_reconfig(with node: NodeRef) 
    {
        node.pointee._next = nil
        node.pointee._pervious = nil
        _entry = node
        _last = node
        _count = 1
    }

    /// This function turns check if the list is empty and reset the _entry and end nodes
    @inline(__always)
    func check_empty() 
    {
        if _last == nil || _entry == nil {
            _entry = nil
            _last = nil
        }
    }

    /// This function push a node in front of an particular node
    ///
    /// - Parameter node: a new node will add in front of this node
    @inline(__always)
    func push_front(node: NodeRef) 
    {
        if let _first_ = _entry {
            if _last == _first_ {
                _entry = node
            }
            Node.push_front(target: _first_, node)
            _count += 1
            return
        }

        // if the list is empty
        entry_reconfig(with: node)
    }

    /// This function push a node in the back of an particular node
    ///
    /// - Parameter node: a new node will push at the back of this node
    @inline(__always)
    func push_back(node: NodeRef) 
    {    
        if let _last_ = _last {
            Node.push_back(target: _last_, node)
            _last = node
            _count += 1
            return
        }
        // if the list is empty
        entry_reconfig(with: node)
    }

    /// Remove a node from the list and push it to the stack, return the value it contains
    ///
    /// - Parameter node: the node to remove
    @inline(__always)
    func remove(_ node: NodeRef) -> T? 
    {
        let ret = node.pointee.item
        _count -= 1
        // remove strong reference
        node.pointee.item = nil
        Node.pop(node: node)
        stack_push(&_trashcan, node)
        check_empty()
        return ret
    }

    /// Create and allocate a new node in heap
    ///
    /// - Parameter element: initial value
    @inline(__always)
    func make_new_node()
    {
        make_new_nodes(count: estimate_nodes_should_alloc())
    }
    
    @inline(__always)
    func make_new_nodes(count: Int) {
        let nodep: NodeRef = allocator.allocate(capacity: count)
        let emptyNodeTemplate = Node(item: nil)

        for i in 0..<count {
            nodep.advanced(by: i).initialize(to: emptyNodeTemplate)
            stack_push(&_trashcan, nodep.advanced(by: i))
        }
        
        self._capacity += count
        
        _cleanup_stack.append {
            self.allocator.deallocate(pointer: nodep, capacity: count)
        }
    }
    
    @inline(__always)
    func estimate_nodes_should_alloc() -> Int {
        return Swift.max(self._capacity/8, 5)
    }
    
    
    /// Get a reusable node from the trashcan stack
    ///
    /// - Parameter output: the pointer to the new node will write to here
    /// - Returns: if we recycle the node successfully
    @inline(__always)
    func attempt_recycle_node(to output: inout NodeRef?) -> Bool
    {    
        stack_pop(&self._trashcan, &output)
        
        if output == nil {
            return false
        }
        
        output!.pointee._next = nil
        output!.pointee._pervious = nil
        output!.pointee.item = nil
        
        return true
    }
    
    /// Get a node to use from either reusable nodes or allocate a new one
    ///
    /// - Parameter value: set the value of the requested node
    @inline(__always)
    func request_node(with value: T) -> NodeRef
    {
        var nodep: NodeRef?
        
        while !attempt_recycle_node(to: &nodep) {
            _ = make_new_node()
        }
        
        nodep!.pointee.item = value
        return nodep!
    }
    
    /// Get a pointer to the node at index
    ///
    /// - Parameter index: which node
    /// - Returns: the pointer to the node
    @inline(__always)
    func iterator_pointer(at index: Int) -> NodeRef?
    {
        guard let first = self._entry,
                index < count else {
            return nil
        }
        
        var it = first
        
        
        for _ in 0..<index {
            it = it.pointee._next!
        }
    
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
        if count <= self._capacity {
            return
        }

        make_new_nodes(count: self._capacity - self.count)
    }

    @discardableResult
    public func remove(at index: Int) -> T? {

        if index == startIndex {
            return popFirst()
        } else if index == endIndex {
            return removeLast()
        }
        
        guard let ptr = iterator_pointer(at: index) else {
            return nil
        }
        
        return remove(ptr)
    }

    @discardableResult
    public func popFirst() -> T? {
        guard let _first_ = _entry else {
            return nil
        }
        _entry = _first_.pointee._next
        return remove(_first_)
    }
    
    @discardableResult
    @inline(__always)
    public func removeFirst() -> T {
        return popFirst()!
    }

    @discardableResult
    public func removeLast() -> T? {
        guard let _last_ = _last else {
            return nil
        }
        _last = _last_.pointee._pervious
        return remove(_last_)
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
        return _entry?.pointee.item
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
        return it!.pointee.item!
    }
}



public struct List<T> {
    
    public struct NodeHeader {
        var prev: Node
        var next: Node
    }
    public final class Node : ManagedBuffer<NodeHeader, T> {
        
    }
}
