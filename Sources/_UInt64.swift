struct _UInt64 {
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
    
    
    static func >> (lhs: _UInt64, rhs: _UInt64) -> _UInt64 {
        return _UInt64(lower: lhs.lower >> rhs.lower,
                       upper: lhs.upper >> rhs.upper)
    }
    
    static func << (lhs: _UInt64, rhs: _UInt64) -> _UInt64 {
        let newLower32bits = lhs.lower << rhs.lower
        var newHigher32bits = (lhs.upper << rhs.upper)
        
        if (lhs.lower | rhs.lower) >= (UInt32(1) << 31) {
            newHigher32bits |= 1
        }
        
        return _UInt64(lower: newLower32bits,
                       upper: newHigher32bits)
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
    
    init(lower: UInt32, upper: UInt32) {
        self.lower = lower
        self.upper = upper
    }
}
