
public struct Queue<T> {
    var ina = [T]()
    var oua = [T]()
    
    public mutating func enqueue(item: T) {
        ina.append(item)
    }
    
    public mutating func dequeue() -> T {
        if oua.isEmpty {
            self.oua = ina.reversed()
            self.ina.removeAll()
        }
        return oua.removeLast()
    }
}
