
@testable import DataStructure

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
//        list.reserveCapacity(count: 450000)

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
