

internal
func stack_push<T: ForwardNode>(_ stack: inout UnsafeMutablePointer<T>?,
                _ pointer: UnsafeMutablePointer<T>)
{
    pointer.pointee._next = stack
    stack = pointer
}

internal
func stack_pop<T: ForwardNode>(_ stack: inout UnsafeMutablePointer<T>?,
               _ out: inout UnsafeMutablePointer<T>?)
{
    guard let _stack = stack else {
        return
    }

    stack = _stack.pointee._next

    out = _stack
    out?.pointee._next = nil
}

internal
func stack_count<T: ForwardNode>(_ stack:  UnsafeMutablePointer<T>?) -> Int
{
    var count = 0
    var local = stack

    while local != nil {
        local = local?.pointee._next
        count += 1
    }
    return count
}


