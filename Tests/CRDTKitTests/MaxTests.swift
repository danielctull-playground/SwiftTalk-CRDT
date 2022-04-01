
import CRDTKit
import XCTest

final class MaxTests: XCTestCase {
    
    func testCommutativity() {
        for _ in 0..<1000 {
            let a = Max(value: Int.random)
            let b = Max(value: Int.random)
            XCTAssertEqual(a.merging(b), b.merging(a))
        }
    }
    
    func testIdempotency() {
        for _ in 0..<1000 {
            let a = Max(value: Int.random)
            XCTAssertEqual(a.merging(a), a)
        }
    }
    
    func testAssociativity() {
        for _ in 0..<1000 {
            let a = Max(value: Int.random)
            let b = Max(value: Int.random)
            let c = Max(value: Int.random)
            XCTAssertEqual(a.merging(b).merging(c), a.merging(b.merging(c)))
        }
    }
}

extension Int {
    
    fileprivate static var random: Int {
        .random(in: Int.min..<Int.max)
    }
}
