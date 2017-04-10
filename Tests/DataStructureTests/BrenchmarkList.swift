
@testable import DataStructure
import Foundation

extension DataStructureTests {

    func test_brenchmark_list_ref() {
        let list = LinkedList<SharedTestRefType>()

        measure {
            for _ in 0..<300000 {
                list.append(SharedTestRefType())
            }
            for _ in 0..<500 {
                _ = list.removeLast()
            }
    
            for _ in 0..<150000 {
                list.append(SharedTestRefType())
            }
        }

        printSeparator()
    }
    
    func test_brenchmark_list_val() {
        let list = LinkedList<SharedTestValueType>()

        measure {
            for _ in 0..<300000 {
                list.append(SharedTestValueType())
            }

            for _ in 0..<500 {
                _ = list.removeLast()
            }
        
            for _ in 0..<150000 {
                list.append(SharedTestValueType())
            }
        }

        printSeparator()
    }
}
