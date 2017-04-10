
public struct RingBuffer<T> : Collection {

    var storage: Array<T>
    
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
        storage = Array<T>()
        storage.reserveCapacity(capacity + 1)
    }
    
    public mutating func enqueue(item: T) {
        if writeIndex >= self.storage.count && storage.count <= storage.capacity {
            storage.append(item)
        } else {
            storage[writeIndex] = item
        }
        constraintedIncrement(&writeIndex, constraint: storage.capacity)
    }
    
    @discardableResult
    public mutating func dequeue() -> T? {
        let retainedReadIndex = readIndex
        constraintedIncrement(&readIndex, constraint: storage.capacity)
        return storage[retainedReadIndex]
    }
    
    public var isEmpty: Bool {
        return readIndex == writeIndex
    }
    
    public var isFull: Bool {
        return readIndex == (writeIndex + 1) % (storage.capacity)
    }
    
    @inline(__always)
    func localIndex(of raw: Int) -> Int {
        if  readIndex > writeIndex {
            return (readIndex + raw) % (storage.capacity)
        }
        return (readIndex + raw) % (storage.capacity - 1)
    }
    
    public subscript(index: Int) -> T {
        get {
            return storage[localIndex(of: index)]
        } set {
            storage[localIndex(of: index)] = newValue
        }
    }
}
