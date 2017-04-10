import CKit

internal protocol ForwardNode {
    associatedtype Element
    var _next: UnsafeMutablePointer<Self>? { get set }
    var item: Element? { get set }
    init(item: Element?)
}

internal protocol BackwardNode {
    associatedtype Element
    var _pervious: UnsafeMutablePointer<Self>? { get set }
    var item: Element? { get set }
}

internal protocol BidirectionalNode: ForwardNode, BackwardNode {
    
}

func sizeof<T>(_: T.Type) -> Int {
    return MemoryLayout<T>.size
}

@inline(__always)
func constraintedIncrement<T: Integer>(_ i: inout T, constraint: T) {
    i = (i + 1) % constraint
}
