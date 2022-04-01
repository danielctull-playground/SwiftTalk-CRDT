
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
}

extension Int {
    
    fileprivate static var random: Int {
        .random(in: Int.min..<Int.max)
    }
}
