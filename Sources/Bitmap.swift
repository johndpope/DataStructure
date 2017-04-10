import CKit

#if arch(x86_64) || arch(arm64)
typealias InternalStorageType = UInt

extension InternalStorageType {
    init(lower: UInt32, upper: UInt32) {
        self = UInt(upper) << 31 + UInt(lower)
    }
}
#else
typealias InternalStorageType = _UInt64
#endif

private var __width__ = MemoryLayout<BitMapStorage>.size * 8

extension InternalStorageType {
    init(compression: Int8, arrayIndex: InternalStorageType) {
        self = arrayIndex << (InternalStorageType(__width__) - InternalStorageType(compression))
    }
}

struct BitMapStorage {

    var i: InternalStorageType
    
    func value(from rate: Int8) -> InternalStorageType {
        return InternalStorageType(i) & InternalStorageType(1 << rate - 1)
    }
    
    func arrayIndex(from rate: Int8) -> InternalStorageType {
        let rate = InternalStorageType(rate)
        return i >> (InternalStorageType(MemoryLayout<InternalStorageType>.size * 8) - InternalStorageType(rate))
    }
}

public struct Bitmap {
    var bits = [BitMapStorage]()

    var compressionRate: CompressionRate
    var count = 0
    
    public enum CompressionRate: Int8 {
        case high = 16
        case medium = 32
        case low = 48
    }
    
    private var width: Int {
        return __width__ - Int(self.compressionRate.rawValue)
    }

    public init(compressionRate: CompressionRate = .medium) {
        self.compressionRate = compressionRate
    }

    @discardableResult
    mutating func switchOn(bit index: Int) -> Bool {

        let arrayIndex = InternalStorageType(index/width)
        let bitIndex = index%width
        for (idx, int) in self.bits.enumerated() {
            if int.arrayIndex(from: self.compressionRate.rawValue) == arrayIndex {
                bits[idx].i |= InternalStorageType(1 << bitIndex)
                return true
            }
        }
        return false
    }
    
    @discardableResult
    mutating func switchOff(bit index: Int) -> Bool {
        
        let arrayIndex = InternalStorageType(index/width)
        let bitIndex = index%width
        
        for (idx, int) in self.bits.enumerated() {
            if int.arrayIndex(from: self.compressionRate.rawValue) == arrayIndex {
                bits[idx].i ^= InternalStorageType(1 << bitIndex)
                return true
            }
        }
        return false
    }

    public subscript(index: Int) -> Bool {
        get {
            let arrayIndex = InternalStorageType(index/width)
            let bitIndex = index%width
            

            for int in self.bits {
                let idx = int.arrayIndex(from: self.compressionRate.rawValue)
                if idx == arrayIndex {
                    return (int.i & UInt(1 << bitIndex)) != 0
                }
            }
            
            return false
        } set {
            
            if !(newValue ? switchOn(bit: index) : switchOff(bit: index)) {

                let arrayIndex = index/width
                let bitIndex = index%width

                assert(arrayIndex <= (1 << Int(compressionRate.rawValue)), "the index \(index) is bigger than this compression method can hold")
                
                var raw = BitMapStorage(i:
                    InternalStorageType(compression: self.compressionRate.rawValue,
                                        arrayIndex: InternalStorageType(arrayIndex))
                )

                if newValue {
                    raw.i |= InternalStorageType(newValue ? 1 << bitIndex : 0)
                }
                                
                self.bits.append(raw)
            }
        }
    }
}

