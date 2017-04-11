
import CKit

public struct BipBuffer<T> : Collection {

    var storage: Array<T>
    
    var readIndex = 0
    var writeIndex = 0
    var filp = false
    
    
    public typealias Index = Int
    
    public var startIndex = 0
    public var endIndex: Int {
        return (self.storage.count / 2) - count
    }
    
    public func index(after i: Int) -> Int {
        return i + 1
    }
    
    public var capacity: Int {
        return self.storage.count / 2
    }
    
    public var count: Int {
        if readIndex >= writeIndex {
            return (capacity) - (readIndex - writeIndex)
        } else {
            return writeIndex - readIndex
        }
    }
    
    public var isEmpty: Bool {
        return (readIndex == writeIndex) && !filp
    }
    
    public var isFull: Bool {
        return (readIndex == writeIndex) && filp
    }
    
    public init(capacity: Int) {
        storage = Array<T>()
        storage.reserveCapacity(capacity * 2)
        
    }
    
    public mutating func enqueue(item: T) {
        if writeIndex >= self.storage.count/2
            && storage.count/2 <= self.capacity {
            storage.insert(item, at: writeIndex)
            storage.append(item)
        } else {
            storage[writeIndex] = item
            storage[(writeIndex + storage.count/2) % (storage.count/2)] = item
        }
    
        incrementWriteIndex()
    }
    
    public subscript(index: Int) -> T {
        get {
            return storage[localIndex(of: index)]
        } set {
            storage[index % storage.capacity/2] = newValue
            storage[(index + storage.count/2) % (storage.count/2)] = newValue
        }
    }
    
    @discardableResult
    public mutating func dequeue() -> T? {
        incrementReadIndex()
        return self.storage[(readIndex - 1) |%| (storage.capacity/2)]
    }
    
    func localIndex(of idx: Int) -> Int {
        return (readIndex + idx) |%| (storage.capacity / 2)
    }
    
    mutating func incrementWriteIndex() {
        constraintedIncrement(&writeIndex, constraint: storage.capacity/2)
        if writeIndex == readIndex {
            filp = true
        }
    }
    
    mutating func incrementReadIndex() {
        constraintedIncrement(&readIndex, constraint: storage.capacity/2)
        if readIndex == writeIndex {
            filp = false
        }
    }
}

extension BipBuffer {
    public mutating func withUnsafeMutablePointer<Result>(
        startIndex: Int,
        blk: (UnsafeMutablePointer<T>) throws -> Result) rethrows -> Result {
        return try blk(&(self.storage[localIndex(of: startIndex)]))
    }

    public func withUnsafeBytes<R>(
        startIndex: Int,
        body: (UnsafeRawBufferPointer?) throws -> R) rethrows -> R {
        
        return try withoutActuallyEscaping(body) { __body__ in
            try storage.withUnsafeBytes {
                let advancedPointer = $0.baseAddress!.advanced(by: startIndex)
                let bufferPointer = UnsafeBufferPointer<T>(
                    start: advancedPointer.assumingMemoryBound(to: T.self),
                    count: self.count
                )
                return try __body__(UnsafeRawBufferPointer(bufferPointer))
            }
        }
    }
    
    public mutating func withUnsafeMutableBytes<R>(
        startIndex: Int,
        body: (UnsafeMutableRawBufferPointer?) throws -> R) rethrows -> R
    {
        return try withoutActuallyEscaping(body) { __body__ in
            try storage.withUnsafeMutableBytes {
                let advancedPointer = $0.baseAddress!.advanced(by: startIndex)
                let bufferPointer = UnsafeMutableBufferPointer<T>(
                    start: advancedPointer.assumingMemoryBound(to: T.self),
                    count: self.count
                )
                return try __body__(UnsafeMutableRawBufferPointer(bufferPointer))
            }
        }
    }
    
    public func withUnsafeBufferPointer<R>(
        startIndex: Int,
        body: (UnsafeBufferPointer<T>?) throws -> R) rethrows -> R {
        return try storage.withUnsafeBufferPointer {
            let advanced = $0.baseAddress?.advanced(by: startIndex)
            return try body(UnsafeBufferPointer(start: advanced,
                                                count: self.count))
        }
    }
    
    public mutating func withUnsafeMutableBufferPointer<R>(
        startIndex: Int,
        body: (UnsafeMutableBufferPointer<T>?) throws -> R) rethrows -> R {
        return try storage.withUnsafeMutableBufferPointer {
            let advanced = $0.baseAddress?.advanced(by: startIndex)
            return try body(UnsafeMutableBufferPointer(start: advanced,
                                                       count: self.count))
        }
    }
}
