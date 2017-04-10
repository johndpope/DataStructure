
typealias Node = BidirectionalNode

struct _Queue<T: Node> {
    var entry: UnsafeMutablePointer<T>?
    var end: UnsafeMutablePointer<T>?
    
    mutating func entry_reconf(with node: UnsafeMutablePointer<T>)
    {
        node.pointee._next = nil
        node.pointee._pervious = nil
        entry = node
        end = node
    }
    
    mutating func check_empty()
    {
        if end == nil || entry == nil {
            entry = nil
            end = nil
        }
    }
    
    mutating func push_front(node: UnsafeMutablePointer<T>)
    {
        if let _first_ = entry {
            if end == _first_ {
                entry = node
            }
            list_node_push_front(_first_, node)
            return
        }
        
        // if the list is empty
        entry_reconf(with: node)
    }
    
    mutating func push_back(node: UnsafeMutablePointer<T>)
    {
        if let _end_ = end {
            list_node_push_back(_end_, node)
            end = node
            return
        }
        
        entry_reconf(with: node)
    }
    
    mutating func pop_front() -> UnsafeMutablePointer<T>?
    {
        guard let _entry_ = entry else {
            return nil
        }
        entry = _entry_.pointee._next
        remove(_entry_)
        return _entry_
    }
    
    mutating func pop_back() -> UnsafeMutablePointer<T>?
    {
        guard let _end_ = end else {
            return nil
        }
        end = _end_.pointee._pervious
        remove(_end_)
        return _end_
    }
    
    mutating func remove(_ node: UnsafeMutablePointer<T>)
    {
        list_node_pop(node)
        check_empty()
    }
}

func list_node_push_back<T: Node>(_ list: UnsafeMutablePointer<T>,
                         _ node: UnsafeMutablePointer<T>) {
    node.pointee._next = list.pointee._next
    list.pointee._next?.pointee._pervious = node
    node.pointee._pervious = list
    list.pointee._next = node
}

func list_node_push_front<T: Node>(_ list: UnsafeMutablePointer<T>,
                          _ node: UnsafeMutablePointer<T>) {
    list.pointee._pervious?.pointee._next = node
    node.pointee._pervious = list.pointee._pervious
    list.pointee._pervious = node
    node.pointee._next = list
}

func list_node_pop<T: Node>(_ node: UnsafeMutablePointer<T>) {
    node.pointee._next?.pointee._pervious = node.pointee._pervious
    node.pointee._pervious?.pointee._next = node.pointee._next
}

