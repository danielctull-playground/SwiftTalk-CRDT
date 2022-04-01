
import CRDTKit
import XCTest

final class GrowOnlyCounterTests: XCTestCase {

    func testBehavior() {
        var a = GrowOnlyCounter(10)
        var b = GrowOnlyCounter(0)
        b.merge(a)
        XCTAssertEqual(b.value, 10)
        a += 1
        b += 1
        a.merge(b)
        b.merge(a)
        XCTAssertEqual(a.value, 12)
        XCTAssertEqual(b.value, 12)
    }
}

extension Int {

    fileprivate static var random: Int {
        .random(in: Int.min..<Int.max)
    }
}
