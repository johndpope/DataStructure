
import CKit

public class Stack<T> : Collection {
    
    public typealias NodeRef = UnsafeMutablePointer<Node>
    
    var _entry: NodeRef?
    var _trashcan: NodeRef?
    
    var _count: Int = 0
    var _capacity: Int = 0
    var _cleanup = [() -> Void]()
    
    public var count: Int {
        return _count
    }
    
    public func reserveCapacity(count: Int) 
    {
        if count <= self._capacity {
            return
        }
        
        make_new_nodes(count: count - self.count)
    }
    
    public func push(item: T) {
        stack_push(&_entry, request_node(with: item))
        _count += 1
    }
    
    public func popFirst() -> T? {
        var trash: NodeRef?
        let ret = _entry?.pointee.item
        _entry?.pointee.item = nil
        stack_pop(&_entry, &trash)
        if let trash = trash {
            stack_push(&_trashcan, trash)
        }
        _count -= 1
        return ret
    }
    
    deinit {
        _cleanup.forEach{$0()}
    }
}

public extension Stack {
    public struct Node : ForwardNode {
        public typealias Element = T
        var item: T?
        var _next: NodeRef?
        init(item: T?) {
            self.item = item
        }
    }
}

public extension Stack {
    @inline(__always)
    func iterator_pointer(at index: Int) -> NodeRef? {
        guard let entry = self._entry,
            index < count else {
                return nil
        }
        var it = entry
        for _ in 0..<index {
            it = it.pointee._next!
        }
        return it
    }
    
    @inline(__always)
    func recount() {
        self._count = stack_count(_entry)
    }
    
    @inline(__always)
    func request_node(with value: T) -> NodeRef 
    {
        var nodep: NodeRef?

        while !attempt_recycle_node(to: &nodep) {
            make_new_node()
        }
        
        nodep?.pointee.item = value
        return nodep!
    }
    
    @inline(__always)
    func estimate_nodes_should_alloc() -> Int {
        return Swift.max(self._capacity/8, 5)
    }
    
    @inline(__always)
    func make_new_node() {
        make_new_nodes(count: estimate_nodes_should_alloc())
    }
    
    @inline(__always)
    func make_new_nodes(count: Int)
    {
        let nodep = NodeRef.allocate(capacity: count)
        _capacity += count
        let node = Node(item: nil)
        for i in 0..<count {
            nodep.advanced(by: i).initialize(to: node)
            stack_push(&_trashcan, nodep.advanced(by: i))
        }
        _cleanup.append {
            nodep.deallocate(capacity: count)
        }
    }
    
    @inline(__always)
    func attempt_recycle_node(to output: inout NodeRef?) -> Bool
    {
        stack_pop(&self._trashcan, &output)
        
        if output == nil {
            return false
        }
        
        output!.pointee._next = nil
        output!.pointee.item = nil
        return true
    }
}

public extension Stack {
    
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
    
    public subscript(_ range: Range<Int>) -> Stack<T> {
        return Stack<T>()
    }
    
    public subscript(position: Int) -> Node.Element 
    {
        let it = iterator_pointer(at: position)
        return it!.pointee.item!
    }
}

