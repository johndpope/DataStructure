
public protocol Allocator {
    func allocate<T>(capacity: Int) -> UnsafeMutablePointer<T>
    func deallocate<T>(pointer: UnsafeMutablePointer<T>, capacity: Int)
}

public struct SwiftAllocator : Allocator {
    public func allocate<T>(capacity: Int) -> UnsafeMutablePointer<T> {
        return UnsafeMutablePointer<T>.allocate(capacity: capacity)
    }
    
    public func deallocate<T>(pointer: UnsafeMutablePointer<T>, capacity: Int) {
        pointer.deallocate(capacity: capacity)
    }
}

extension UnsafeMutablePointer {
    public func allocate(with allocator: Allocator, capacity: Int)
        -> UnsafeMutablePointer<Pointee>
    {
        return allocator.allocate(capacity: capacity)
    }
    
    public func deallocate(with allocator: Allocator, capacity: Int)
    {
        return allocator.deallocate(pointer: self, capacity: capacity)
    }
}
