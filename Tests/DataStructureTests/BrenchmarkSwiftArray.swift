
extension DataStructureTests {
    
    func test_brenchmark_array_ref() {
        var array = Array<SharedTestRefType>()
        
        measure {
            for _ in 0..<300000 {
                array.append(SharedTestRefType())
            }
            
            for _ in 0..<500 {
                array.removeLast()
            }
            
            for _ in 0..<150000 {
                array.append(SharedTestRefType())
            }
        }
        
        printSeparator()
    }
    
    func test_brenchmark_array_val() {
        var array = Array<SharedTestValueType>()
        
        measure {
            for _ in 0..<300000 {
                array.append(SharedTestValueType())
            }
            
            for _ in 0..<500 {
                array.removeLast()
            }
            
            for _ in 0..<150000 {
                array.append(SharedTestValueType())
            }
        }
        
        printSeparator()
    }
}
