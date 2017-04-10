//
//@testable import DataStructure
//
//extension DataStructureTests {
//    
//    func test_brenchmark_stack_ref() {
//        let stack = Stack<SharedTestRefType>()
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
//}
