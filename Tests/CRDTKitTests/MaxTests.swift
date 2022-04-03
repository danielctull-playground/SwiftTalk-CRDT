
import CRDTKit
import XCTest

final class MaxTests: XCTestCase {
    
    func testCommutativity() {
        for _ in 0..<1000 {
            let a = Max(Int.random)
            let b = Max(Int.random)
            XCTAssertEqual(a.merging(b), b.merging(a))
        }
    }
    
    func testIdempotency() {
        for _ in 0..<1000 {
            let a = Max(Int.random)
            XCTAssertEqual(a.merging(a), a)
        }
    }
    
    func testAssociativity() {
        for _ in 0..<1000 {
            let a = Max(Int.random)
            let b = Max(Int.random)
            let c = Max(Int.random)
            XCTAssertEqual(a.merging(b).merging(c), a.merging(b.merging(c)))
        }
    }

    func testBehavior() {
        var a = Max(10)
        var b = Max(0)
        b.merge(a)
        XCTAssertEqual(b.value, 10)
        a.value += 1
        b.value += 1
        a.merge(b)
        b.merge(a)
        XCTAssertEqual(a.value, 11)
        XCTAssertEqual(b.value, 11)
    }
}
