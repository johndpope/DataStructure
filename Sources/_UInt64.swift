struct _UInt64: Equatable {
    var lower: UInt32
    var upper: UInt32
    
    static func | (lhs: _UInt64, rhs: _UInt64) -> _UInt64 {
        return _UInt64(lower: lhs.lower | rhs.lower,
                       upper: lhs.upper | rhs.upper)
    }
    
    
    static func & (lhs: _UInt64, rhs: _UInt64) -> _UInt64 {
        return _UInt64(lower: lhs.lower & rhs.lower,
                       upper: lhs.upper & rhs.upper)
    }
    
    
    static func ^ (lhs: _UInt64, rhs: _UInt64) -> _UInt64 {
        return _UInt64(lower: lhs.lower ^ rhs.lower,
                       upper: lhs.upper ^ rhs.upper)
    }
    
    
    static prefix func ~ (lhs: _UInt64) -> _UInt64 {
        return _UInt64(lower: ~lhs.lower,
                       upper: ~lhs.upper)
    }
    
    static func |= (lhs: inout _UInt64, rhs: _UInt64) {
        lhs = _UInt64(lower: lhs.lower | rhs.lower,
                      upper: lhs.upper | rhs.upper)
    }
    
    
    static func &= (lhs: inout _UInt64, rhs: _UInt64) {
        lhs = _UInt64(lower: lhs.lower & rhs.lower,
                      upper: lhs.upper & rhs.upper)
    }
    
    
    static func ^= (lhs: inout _UInt64, rhs: _UInt64) {
        lhs = _UInt64(lower: lhs.lower ^ rhs.lower,
                      upper: lhs.upper ^ rhs.upper)
    }
    
    
//    static func >> (lhs: _UInt64, rhs: _UInt64) -> _UInt64 {
//        var newLower32bits = lhs.lower >> rhs.lower
//        let newHigher32bits = lhs.upper >> rhs.upper
//        
//        if lhs.upper % 2 != 0 {
//            newLower32bits |= (1 << 31)
//        }
//        
//        return _UInt64(lower: newLower32bits,
//                       upper: newHigher32bits)
//    }

    static func >> (lhs: _UInt64, shifts: Int8) -> _UInt64
    {
        if shifts == 0 {
            return lhs
        }
        
        var lower = shifts >= 32 ? 0 : (lhs.lower >> UInt32(shifts))
        let upper = shifts >= 32 ? 0 : (lhs.upper >> UInt32(shifts))
        
        lower |= (lhs.upper << UInt32(abs(32 - shifts)))
        
        if shifts >= 32 {
            lower |= (lhs.upper >> UInt32(abs(32 - shifts)))
        }
        
        return _UInt64(lower: lower, upper: upper)
    }
    
    static func >> (lhs: _UInt64, shifts: _UInt64) -> _UInt64
    {
        return lhs >> Int8(shifts.lower)
    }
    
    
    static func << (lhs: _UInt64, shifts: Int8) -> _UInt64
    {
        if shifts == 0 {
            return lhs
        }
        
        let lower = shifts >= 32 ? 0 : (lhs.lower << UInt32(shifts))
        var upper = shifts >= 32 ? 0 : (lhs.upper << UInt32(shifts))

        upper |= (lhs.lower >> UInt32(abs(32 - shifts)))

        if shifts >= 32 {
            upper |= (lhs.lower << UInt32(abs(32 - shifts)))
        }
    
        return _UInt64(lower: lower, upper: upper)
    }

    static func << (lhs: _UInt64, shifts: _UInt64) -> _UInt64
    {
        return lhs << Int8(shifts.lower)
    }
    
    static func - (lhs: _UInt64, rhs: _UInt64) -> _UInt64 {
        let upper = lhs.upper - rhs.upper
        var lower = UInt32.max
        
        if rhs.lower > lhs.lower {
            lower -= (rhs.lower - lhs.lower)
        } else {
            lower = (lhs.lower - rhs.lower)
        }
        
        return _UInt64(lower: lower, upper: upper)
    }
    
//    0111111111111
//    1000000000100
//    0000010000010
//    0111110000010
    
//    0000010000010
//    0000000000100
    
//    0000001111101
//    0111110000010
    
// +  0000010000111
//    0000000000000
    
    
//    0111110000010
//    
    static func ==(lhs: _UInt64, rhs: _UInt64) -> Bool {
        return lhs.lower == rhs.lower && lhs.upper == rhs.upper
    }
    
    static let max = _UInt64(lower: UInt32.max,
                             upper: UInt32.max)
    
    init(_ i: Int8) {
        self.upper = 0
        self.lower = UInt32(i)
    }
    
    init(_ i: Int16) {
        self.upper = 0
        self.lower = UInt32(i)
    }
    
    init(_ i: Int32) {
        self.upper = 0
        self.lower = UInt32(i)
    }
    
    init(_ i: UInt8) {
        self.upper = 0
        self.lower = UInt32(i)
    }
    
    init(_ i: UInt16) {
        self.upper = 0
        self.lower = UInt32(i)
    }
    
    init(_ i: UInt32) {
        self.upper = 0
        self.lower = UInt32(i)
    }
    
    init(_ i: _UInt64) {
        self.upper = i.upper
        self.lower = i.lower
    }
    
    #if arch(x86_64) || arch(arm64)
    init(_ i: Int) {
        self.upper = UInt32(i >> 32)
        self.lower = UInt32(UInt(UInt32.max) & UInt(i))
    }
    
    
    #endif
    
    init(lower: UInt32, upper: UInt32) {
        self.lower = lower
        self.upper = upper
    }
}

extension String {
    init(_ i: _UInt64, radix: Int) {
        var s = ""
        for ix in (0..<32).reversed() {
            s.append(((i.upper & UInt32(1 << ix)) != 0) ? "1" : "0")
        }
        
        for ix in (0..<32).reversed() {
            s.append(((i.lower & UInt32(1 << ix)) != 0) ? "1" : "0")
        }
        self = s
    }
}
