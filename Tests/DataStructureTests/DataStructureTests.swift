
@_exported import CKit
import Foundation
import Dispatch

@_exported import XCTest
@testable import DataStructure

struct SharedTestValueType {
    var _0 = 0
    var _1 = 0
    var _2 = 0
    var _3 = 0
    var _4 = 0
    var _5 = 0
    var _6 = 0
    var _7 = 0
    var _8 = 0
    
    var i : Int {
        return _0
    }
    
    init() {
    }
    
    init(_ val: Int) {
        self._0 = val
    }
}

class SharedTestRefType {
    var _0 = SharedTestValueType()
    var i : Int {
        return _0.i
    }
    
    init() {}
    init(_ v: Int) {
        self._0 = SharedTestValueType(v)
    }
    
    deinit {
//        print("cleaning up")
    }
}

func printSeparator() {
    print("\n\n")
}

class DataStructureTests: XCTestCase {

//    var array = Array<SharedTestValueType>()
//    var arrayv = Array<SharedTestRefType>()
//    
//    func test_brenchmark_array() {
//        
//        print("")
//        print("")
//        
//        self.array.reserveCapacity(300000)
//        measure {
//            for _ in 0..<300000 {
//                self.array.append(SharedTestValueType())
//            }
//
//            for _ in 0..<500 {
//                self.array.removeLast()
//            }
//
//            for _ in 0..<150000 {
//                self.array.append(SharedTestValueType())
//            }
//        }
//    }
//    
//    func test_brenchmark_arrayv() {
//        print("")
//        print("")
//        self.arrayv.reserveCapacity(300000)
//        measure {
//            for _ in 0..<300000 {
//                self.arrayv.append(SharedTestRefType())
//            }
//            
//            for _ in 0..<500 {
//                self.arrayv.append(SharedTestRefType())
//            }
//            
//            for _ in 0..<300000 {
//                self.arrayv.append(SharedTestRefType())
//            }
//        }
//    }
    
    static var allTests : [(String, (DataStructureTests) -> () throws -> Void)] {
        return [
            
        ]
    }
}
