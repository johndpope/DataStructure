
private func constraintedIncrement<T: Integer>(_ i: inout T, constraint: T) {
    i = (i + 1) % constraint
}

public struct RingBuffer<T> : Collection {

    var storage: Array<T?>
    
    var readIndex = 0
    var writeIndex = 0
    
    public typealias Index = Int
    
    public var capacity: Int {
        return self.storage.count - 1
    }
    
    public var startIndex: Int {
        return 0
    }
    
    public var endIndex: Int {
        return capacity - count
    }

    public func index(after i: Int) -> Int {
        return i + 1
    }

    public var count: Int {
        if readIndex > writeIndex {
            return (capacity + 1) - (readIndex - writeIndex)
        } else {
            return writeIndex - readIndex
        }
    }
    
    public init(capacity: Int) {
        storage = Array<T?>(repeating: nil, count: capacity + 1)
    }
    
    public mutating func enqueue(item: T) {
        storage[writeIndex] = item
        constraintedIncrement(&writeIndex, constraint: storage.count)
    }
    
    @discardableResult
    public mutating func dequeue() -> T? {
        let retainedReadIndex = readIndex
        constraintedIncrement(&readIndex, constraint: storage.count)
        return storage[retainedReadIndex]
    }
    
    public var isEmpty: Bool {
        return readIndex == writeIndex
    }
    
    public var isFull: Bool {
        return readIndex == (writeIndex + 1) % storage.count
    }
    
    @inline(__always)
    func localIndex(of raw: Int) -> Int {
        if  readIndex > writeIndex {
            return (readIndex + raw) % (storage.count)
        }
        return (readIndex + raw) % (storage.count - 1)
    }
    
    public subscript(index: Int) -> T {
        get {
            assert(index < self.capacity, "index out of range")
            return storage[localIndex(of: index)]!
        } set {
            assert(index < self.capacity, "index out of range")
            storage[localIndex(of: index)] = newValue
        }
    }
}
