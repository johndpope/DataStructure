
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

public func cr(_ ir: UInt) -> Int {
    print("passed")
    for i in 0..<(MemoryLayout<UInt>.size * 8 - 1) {
        if UInt(1 << i) | (ir << UInt(i)) == 0 {
            return i
        }
    }
    return 0
}

func printSeparator() {
    print("\n\n")
}

class DataStructureTests: XCTestCase {

    func test_bitmap() {
        var bitmap = Bitmap()
        
        bitmap[2] = true
        bitmap[1] = true
//
        print(bitmap.bits.map {
            String($0.i, radix: 2)
        })
//
        XCTAssertEqual(bitmap[2], true)
        XCTAssertEqual(bitmap[1], true)
        
        bitmap[1] = false
        
        XCTAssertEqual(bitmap[1], false)
        XCTAssertEqual(bitmap[0], false)
        
        XCTAssertEqual(bitmap[2], true)
        
        bitmap[799] = true
        XCTAssertEqual(bitmap[799], true)
    }
   
    func test_bitmap_low() {
        var bitmap = Bitmap(compressionRate: .low)
//        
        bitmap[2] = true
        bitmap[1] = true
//        //
        print(bitmap.bits.map {
            String($0.i, radix: 2)
        })
        //
        XCTAssertEqual(bitmap[2], true)
        XCTAssertEqual(bitmap[1], true)
//
        bitmap[1] = false
//
        XCTAssertEqual(bitmap[1], false)
        XCTAssertEqual(bitmap[0], false)
        
        XCTAssertEqual(bitmap[2], true)
        
        bitmap[799] = true
        XCTAssertEqual(bitmap[799], true)
        
        bitmap[12341234134124] = true
        XCTAssertEqual(bitmap[12341234134124], true)
//        XCTAssertEqual(bitmap[12341234134125], false)
//        
//        print(bitmap.bits.map {
//            String($0.i, radix: 2)
//        })
        //
    }
    
    func test_bitmap_high() {
        var bitmap = Bitmap(compressionRate: .high)
        
        bitmap[2] = true
        bitmap[1] = true
        //
        print(bitmap.bits.map {
            String($0.i, radix: 2)
        })
        //
        XCTAssertEqual(bitmap[2], true)
        XCTAssertEqual(bitmap[1], true)
        
        bitmap[1] = false
        
        XCTAssertEqual(bitmap[1], false)
        XCTAssertEqual(bitmap[0], false)
        
        XCTAssertEqual(bitmap[2], true)
        
        bitmap[799] = true
        XCTAssertEqual(bitmap[799], true)
    }
    
    static var allTests : [(String, (DataStructureTests) -> () throws -> Void)] {
        return [
            
        ]
    }
}
