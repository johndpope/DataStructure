
@testable import DataStructure
import XCTest

extension DataStructureTests  {

    func _test_bitmap_general(_ bitmap: inout Bitmap) {
        bitmap[2] = true
        bitmap[1] = true
        XCTAssertEqual(bitmap[2], true)
        XCTAssertEqual(bitmap[1], true)
        bitmap[1] = false
        XCTAssertEqual(bitmap[1], false)
        XCTAssertEqual(bitmap[0], false)
        XCTAssertEqual(bitmap[2], true)

        bitmap[799] = true
        XCTAssertEqual(bitmap[799], true)
    }

    func test_bitmap_default() {
        var bitmap = Bitmap()
        _test_bitmap_general(&bitmap)
    }

    func test_bitmap_sparsity_low() {
        var bitmap = Bitmap(sparsity: .low)
        _test_bitmap_general(&bitmap)
    }

    func test_bitmap_sparsity_high() {
        var bitmap = Bitmap(sparsity: .high)
        _test_bitmap_general(&bitmap)
    }
}
