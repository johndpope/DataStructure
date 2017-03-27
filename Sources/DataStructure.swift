@inline(__always)
internal func compare_und_swap<T: Equatable>(_ local: inout T, _ dest: UnsafeMutablePointer<T>, _ val: T) -> Bool {
    // if the destination remain the same, then assign new value
    if local == dest.pointee {
        dest.pointee = val
        return true;
    }
    return false
}
