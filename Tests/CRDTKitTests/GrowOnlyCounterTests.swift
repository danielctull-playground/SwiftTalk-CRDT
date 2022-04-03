
import CRDTKit
import XCTest

extension GrowOnlyCounter: Randomizable where Value: Randomizable {
    static var random: GrowOnlyCounter<Value> { GrowOnlyCounter(.random) }
}

final class GrowOnlyCounterTests: XCTestCase {

    func testLaws() {
        // Because of its internals, need to use value of the GrowOnlyCounter
        // to assert equality with.
        GrowOnlyCounter<Int>.testCommutativity(equating: \.value)
        GrowOnlyCounter<Int>.testAssociativity(equating: \.value)
        GrowOnlyCounter<Int>.testIdempotency(equating: \.value)
    }

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
