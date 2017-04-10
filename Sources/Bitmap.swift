
public struct Bitmap {
    
    var bits = [Storage]()
    
    #if arch(x86_64) || arch(arm64)
    typealias IntType = UInt
    #else
    typealias IntType = _UInt64
    #endif

    var sparsity: Sparsity
    var intWidth = 64
    var width: Int {
        return intWidth - Int(self.sparsity.rawValue)
    }
    
    public init(sparsity: Sparsity = .medium) {
        self.sparsity = sparsity
    }

    public subscript(index: Int) -> Bool {
        get {
            return value(at: index)
        } set {
            setValue(at: index, value: newValue)
        }
    }
}

extension Bitmap {
    
    func value(at index: Int) -> Bool {
        let arrayIndex = IntType(index/width)
        
        for int in self.bits {
            let idx = int.arrayIndex(from: self.sparsity.rawValue)
            if idx == arrayIndex {
                return int.i & IntType(1 << (index%width)) != IntType(0)
            }
        }
        
        return false
    }
    
    mutating func setValue(at index: Int, value: Bool) {
        let bitIndex = index%width
        let arrayIndex = IntType(index/width)
        
        for (indx, int) in self.bits.enumerated() {
            let idx = int.arrayIndex(from: self.sparsity.rawValue)
            if idx == arrayIndex {
                bits[indx].set(bit: bitIndex, val: value)
                return
            }
        }
        
        makeStorage(section: IntType(index/width),
                    bitIndex: bitIndex,
                    val: value)
    }
    
    mutating func makeStorage(section idx: IntType, bitIndex: Int, val: Bool) {
        self.bits.append(
            Storage(
                idx << IntType(bitSizeof(IntType.self) - Int(sparsity.rawValue))
                    | IntType(val ? 1 << bitIndex : 0)
            )
        )
    }
}

extension Bitmap {
    struct Storage {
        
        var i: IntType
        
        func value(from rate: Int8) -> IntType {
            return IntType(i) & IntType(1 << rate - 1)
        }
        
        init(_ i: IntType) {
            self.i = i
        }
        
        func arrayIndex(from rate: Int8) -> IntType {
            let rate = IntType(rate)
            return i >> (IntType(bitSizeof(IntType.self)) - IntType(rate))
        }
        
        mutating func set(bit idx: Int, val: Bool) {
            _ = val
                ? (i |= IntType(1 << idx))
                : (i &= (IntType.max ^ IntType(1 << idx)))
        }
        
        init(sparsity: Int8, arrayIndex idx: IntType) {
            self.i = idx << (IntType(bitSizeof(IntType.self)) - IntType(sparsity))
        }
        
    }
}

extension Bitmap {
    public struct Sparsity : RawRepresentable {
        public var rawValue: Int8
        public init?(rawValue: Int8) {
            if rawValue >= 64 || rawValue == 0 {
                return nil
            }
            self.rawValue = rawValue
        }
        
        public static let low = Sparsity(rawValue: 16)!
        public static let medium = Sparsity(rawValue: 32)!
        public static let high = Sparsity(rawValue: 48)!
    }
}
