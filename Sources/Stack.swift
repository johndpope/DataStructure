
import CKit

internal func stack_push<T: ForwardNode>(_ stackPointer: inout UnsafeMutablePointer<T>?,
                         _ pointer: UnsafeMutablePointer<T>)
{
    pointer.pointee._next = stackPointer
    stackPointer = pointer
}

internal func stack_pop<T: ForwardNode>(_ stackPointer: inout UnsafeMutablePointer<T>?,
                        _ out: inout UnsafeMutablePointer<T>?)
{
    guard let _stackPointer = stackPointer else {
        return
    }
    
    stackPointer = _stackPointer.pointee._next
    out = _stackPointer
    out?.pointee._next = nil
}

internal func stack_items_count<T: ForwardNode>(_ stackPointer:  UnsafeMutablePointer<T>?) -> Int {
    var count = 0
    var local = stackPointer
    
    while local != nil {
        local = local?.pointee._next
        count += 1
    }
    return count
}


public class Stack<T> : Collection {
    
    var _entry: UnsafeMutablePointer<Node>?
    var _trashcan: UnsafeMutablePointer<Node>?
    
    var _count: Int = 0
    
    public var count: Int {
        return _count
    }
    
    public func reserveCapacity(count: Int) {
        if count <= self.count {
            return
        }
        
        for _ in 0 ..< (count - self.count) {
            let nodep = make_new_node(element: nil)
            stack_push(&_trashcan, nodep)
        }
    }
    
    public func push(item: T) {
        stack_push(&_entry, request_node(with: item))
        _count += 1
    }
    
    public func popFirst() -> T? {
        var trash: UnsafeMutablePointer<Node>?
        let ret = _entry?.pointee.storage
        stack_pop(&_entry, &trash)
        if let trash = trash {
            stack_push(&_trashcan, trash)
        }
        _count -= 1
        return ret
    }
    
    deinit {
        var start = _entry
        
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

public extension Stack {
    public struct Node : ForwardNode {
        public typealias Element = T
        var storage: T?
        var _next: UnsafeMutablePointer<Node>?
        init(storage: T?) {
            self.storage = storage
        }
    }
}

public extension Stack {
    @inline(__always)
    func iterator_pointer(at index: Int) -> UnsafeMutablePointer<Node>? {
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
        self._count = stack_items_count(_entry)
    }

    @inline(__always)
    func make_new_node(element: T?) -> UnsafeMutablePointer<Node> {
        let nodep = UnsafeMutablePointer<Node>.allocate(capacity: 1)
        var node = Node(storage: element)
        memcpy(nodep.mutableRawPointer,
               mutablePointer(of: &node).rawPointer, MemoryLayout<Node>.size)
        return nodep
    }
    
    @inline(__always)
    func request_node(with value: T) -> UnsafeMutablePointer<Node> {
        var nodep: UnsafeMutablePointer<Node>?
        if !attempt_recycle_node(to: &nodep) {
            nodep = make_new_node(element: value)
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
        output!.pointee.storage = nil
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
    
    public subscript(position: Int) -> Node.Element {
        let it = iterator_pointer(at: position)
        return it!.pointee.storage!
    }
}

