
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
    
    out = _stackPointer
    out?.pointee._next = nil
    stackPointer = _stackPointer.pointee._next
}

//internal func atomic_stack_push<T: ForwardNode>
//    (_ stackPointer: inout UnsafeMutablePointer<T>,
//     _ pointer: UnsafeMutablePointer<T>) where T.Element : Equatable
//{
//    while !compare_und_swap(&stackPointer, stackPointer, <#T##val: T##T#>) {
//        <#code#>
//    }
//    pointer.pointee._next = stackPointer
//    stackPointer = pointer
//}
//
//internal func atomic_stack_pop<T: ForwardNode>(_ stackPointer: inout UnsafeMutablePointer<T>?,
//                        _ out: inout UnsafeMutablePointer<T>)
//{
//    guard let _stackPointer = stackPointer else {
//        return
//    }
//    
//    out = _stackPointer
//    stackPointer = _stackPointer.pointee._next
//}

internal protocol ForwardNode {
    associatedtype Element
    var _next: UnsafeMutablePointer<Self>? { get set }
    var storage: Element? { get set }
}

internal protocol BackwardNode {
    associatedtype Element
    var _pervious: UnsafeMutablePointer<Self>? { get set }
    var storage: Element? { get set }
}

public struct ListNode<T>: IteratorProtocol, ForwardNode {
    
    public typealias Element = T
    var _next: UnsafeMutablePointer<ListNode<Element>>?
    var _pervious: UnsafeMutablePointer<ListNode<Element>>?
    
    public var storage: Element?
    
    public init(storage: Element) {
        self.storage = storage
        
    }

    public func next() -> Element? {
        return _next?.pointee.storage
    }
    
    public func pervious() -> Element? {
        return _pervious?.pointee.storage
    }
    
    fileprivate static func pop(node: UnsafeMutablePointer<ListNode<T>>)  {
        node.pointee._pervious?.pointee._next = node.pointee._next
        node.pointee._next?.pointee._pervious = node.pointee._pervious
    }
    
    fileprivate static func push_front(target: UnsafeMutablePointer<ListNode<T>>,
                                       _ node: UnsafeMutablePointer<ListNode<T>>) {
        target.pointee._pervious?.pointee._next = node
        target.pointee._pervious = node
        node.pointee._pervious = target.pointee._pervious
        node.pointee._next = target
    }
    
    fileprivate static func push_back(target: UnsafeMutablePointer<ListNode<T>>,
                                      _ node: UnsafeMutablePointer<ListNode<T>>) {
        target.pointee._next?.pointee._pervious = node
        target.pointee._next = node
        node.pointee._next = target.pointee._next
        node.pointee._pervious = target
    }
}

public typealias List<T> = Unmanaged<LinkedList<T>>

public final class LinkedList<T>//: Collection
{
    public typealias SubSequence = LinkedList<T>
    public typealias Node = ListNode<T>
    public typealias Iterator = Node
    public typealias Index = Int
    
    var _lazy_initialized = false
    var _count = 0
    var _first: UnsafeMutablePointer<Node>?
    var _last: UnsafeMutablePointer<Node>?
    var _trashcan: UnsafeMutablePointer<Node>? // stack storing trash nodes
    
//    public subscript(_ range: Range<Int>) -> LinkedList<T> {
//        
//    }
    
//    public func prefix(through position: Int) -> LinkedList<T> {
//        
//    }
    
    
//    /// Pop from an entry of linked nodes
//    ///
//    /// - Parameter baseptr: The first node of the linked nodes (can be _first or trashcan)
//    private func pop(from baseptr: UnsafeMutablePointer<Node>) -> UnsafeMutablePointer<Node> {
//        
//    }
    
    private func list_is_empty() -> Bool {
        return _first == nil && _last == nil
    }
    
    func push_back(node: UnsafeMutablePointer<Node>) {
        if let _last_ = _last {
            if _last == _first {
                _last = node
            }
            Node.push_back(target: _last_, node)
            _count += 1
            return
        }
        
        // if the list is empty
        init_list(with: node)
    }
    
    @inline(__always)
    func init_list(with node: UnsafeMutablePointer<Node>) {
        node.pointee._next = nil
        node.pointee._pervious = nil
        _first = node
        _last = node
    }
    
    @inline(__always)
    private func test_drain() {
        if _last?.pointee._pervious ==
            nil && _first?.pointee._next == nil {
            _first = nil
            _last = nil
        }
    }
    
    private func push_front(node: UnsafeMutablePointer<Node>) {
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
    
    private func pop(_ node: UnsafeMutablePointer<Node>) {
        _count -= 1
        Node.pop(node: node)
        stack_push(&_trashcan, node)
    }
    
    private func pop_back(_ output: inout T?) {
        // no item, what you expect
        guard let _last_ = _last else {
            output = nil
            return
        }
        
        output = _last_.pointee.storage
        pop(_last_)
//        Node.pop(node: _last_)
//        stack_push(&_trashcan, _last_)
//        if _last?.pointee._pervious ==
//            nil && _first?.pointee._next == nil {
//            _first = nil
//            _last = nil
//        }
//        if let pervious = _last_.pointee._pervious {
//            pervious.pointee._next = nil
//            self._last = pervious
//        } else {
//            // drained
//            _first = nil
//            _last = nil
//        }
//        
        // nice to have a trash can right
//        stack_push(&_trashcan, _last_)
    }
    
    private func pop_front(_ output: inout T?) {
        // no item, what you expect
        guard let _first_ = _first else {
            output = nil
            return
        }
        
        output = _first_.pointee.storage
        pop(_first_)
//        Node.pop(node: _first_)
//        stack_push(&_trashcan, _first_)
//        if _last?.pointee._pervious == nil
//            && _first?.pointee._next == nil {
//            _first = nil
//            _last = nil
//        }
//        if let next = _first_.pointee._next {
//            next.pointee._pervious = nil
//            self._first = next
//        } else {
//            // drained
//            _first = nil
//            _last = nil
//        }
        
        // nice to have a trash can right
//        stack_push(&_trashcan, _first_)
    }

    public func makeIterator() -> ListNode<T> {
        return _first!.pointee
    }
    
    public func append(_ item: T) {
        var nodep: UnsafeMutablePointer<Node>?
        stack_pop(&_trashcan, &nodep)

        if nodep == nil {
            nodep = UnsafeMutablePointer<Node>.allocate(capacity: 1)
            var node = Node(storage: item)
            memcpy(nodep!.mutableRawPointer, mutablePointer(of: &node).rawPointer, MemoryLayout<Node>.size)
        }

        self.push_back(node: nodep!)
    }
    
    public init() {}
    
    public func removeFirst() -> T? {
        var ret: T?
        pop_front(&ret)
        return ret
    }

    init(list: LinkedList<T>, from: Int, to: Int) {
        self._first = list._first
        self._count = to - from
        self._lazy_initialized = true
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
    
    public func distance(from start: Int, to end: Int) -> Int {
        return end - start
    }
    
    public var startIndex: Int {
        return 0
    }
    
    public var endIndex: Int {
        return self.count - 1
    }
    
    public func index(_ i: Int, offsetBy n: Int) -> Int {
        return i + n
    }
    
    public func index(_ i: Int, offsetBy n: Int, limitedBy limit: Int) -> Int? {
        return limit > i + n ? limit : i + n
    }
    
    public subscript(position: Int) -> Iterator.Element? {
        var it = makeIterator()
        for _ in 0..<position {
            it = it._next!.pointee
        }
        return it.storage
    }
}
