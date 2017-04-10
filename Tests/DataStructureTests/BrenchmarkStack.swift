
@testable import DataStructure

extension DataStructureTests {
    
//    func test_brenchmark_stack_ref() {
//        let stack = Stack<SharedTestRefType>()
//        
//        stack.reserveCapacity(count: 450000)
//        
//        measure {
//            for _ in 0..<300000 {
//                stack.push(item: SharedTestRefType())
//            }
//            for _ in 0..<500 {
//                _ = stack.popFirst()
//            }
//            
//            for _ in 0..<150000 {
//                stack.push(item: SharedTestRefType())
//            }
//        }
//        
//        printSeparator()
//    }
//    
//    func test_brenchmark_stack_val() {
//        let stack = Stack<SharedTestValueType>()
//        stack.reserveCapacity(count: 450000)
//        
//        measure {
//            for _ in 0..<300000 {
//                stack.push(item: SharedTestValueType())
//            }
//            
//            for _ in 0..<500 {
//                _ = stack.popFirst()
//            }
//            
//            for _ in 0..<150000 {
//                stack.push(item: SharedTestValueType())
//            }
//        }
//        
//        printSeparator()
//    }
    
//    func test_array_stack() {
//        var stack = ArrayQueue<SharedTestValueType>()
// 
//        measure {
//            for _ in 0..<300000 {
//                stack.enqueue(item: SharedTestValueType())
//            }
//            
//            for _ in 0..<500 {
//                _ = stack.dequeue()
//            }
//            
//            for _ in 0..<150000 {
//                stack.enqueue(item: SharedTestValueType())
//            }
//        }
//        
//        printSeparator()
//    }
}
