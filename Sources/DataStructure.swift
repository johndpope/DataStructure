import CKit

internal protocol ForwardNode {
    associatedtype Element
    var _next: UnsafeMutablePointer<Self>? { get set }
    var storage: Element? { get set }
    init(storage: Element?)
}

internal protocol BackwardNode {
    associatedtype Element
    var _pervious: UnsafeMutablePointer<Self>? { get set }
    var storage: Element? { get set }
}
