public struct MinHeap<T: Comparable> {
    
    var storage: Array<T>
    
    public init(capacity: Int) {
        self.storage = Array<T>()
        self.storage.reserveCapacity(capacity)
    }
    
    public init(_ array: Array<T>) {
        self.storage = array.sorted(by: <)
    }

    public mutating func push(item: T) {
        self.storage.append(item)
        order(from: self.storage.count)
    }
    
    public var count: Int {
        return self.storage.count
    }
    
    public var capacity: Int {
        return self.storage.count
    }
    
    public mutating func pop() -> T {
        
        if self.storage.count == 1 {
            return self.storage.removeFirst()
        }
        
        let _min_ = min(self.storage[0], self.storage[1])
        
        if _min_ == self.storage[0] {
            let last = self.storage.removeLast()
            self.storage[0] = last
            sink(1)
        } else {
            let last = self.storage.removeLast()
            self.storage[1] = last
            sink(2)
        }
        
        return _min_
    }
    
    mutating func order(from index: Int) {

        if storage[parent(of: vindex(index))] <= storage[vindex(index)] {
            return
        }

        swap(&storage[vindex(index)], &storage[parent(of: vindex(index))])
        order(from: parent(of: index))
    }
    
    mutating func sink(_ index: Int) {
        
        let lidx = leftChild(of: index)
        let ridx = rightChild(of: index)
        
        if vindex(lidx) > self.storage.count || vindex(ridx) > self.storage.count {
            return
        }
        
        let existsL = vindex(lidx) < self.storage.count
        let existsR = vindex(ridx) < self.storage.count
        
        switch (existsL, existsR) {
        case (true, false):
            if storage[vindex(index)] > storage[vindex(lidx)] {
                swap_and_sink(index, lidx)
            }
            
        case (false, true):
            if storage[vindex(index)] > storage[vindex(ridx)] {
                swap_and_sink(index, ridx)
            }

        default:
            let min = Swift.min(storage[vindex(lidx)],
                            storage[vindex(ridx)])
        
            if storage[vindex(index)] < min {
                return
            }
            
            if min == storage[vindex(lidx)] {
                swap_and_sink(index, lidx)
            } else {
                swap_and_sink(index, ridx)
            }
        }
    }
    
    mutating func swap_and_sink(_ idx: Int, _ aidx: Int) {
        swap(&storage[vindex(idx)], &storage[vindex(aidx)])
        sink(max(idx, aidx))
    }

    func parent(of index: Int) -> Int {
        return (index / 2)
    }
    
    func leftChild(of index: Int) -> Int {
        return 2 * index
    }
    
    func rightChild(of index: Int) -> Int {
        return 2 * index + 1
    }
    
    func vindex(_ idx: Int) -> Int {
        return idx - 1
    }

}
