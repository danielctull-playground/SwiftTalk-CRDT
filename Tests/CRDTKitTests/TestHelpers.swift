
import CRDTKit
import XCTest

protocol Randomizable {
    static var random: Self { get }
}

extension Int: Randomizable {
    static var random: Int { .random(in: Int.min..<Int.max) }
}

extension CRDT where Self: Equatable & Randomizable {

    static func testCommutativity() {
        for _ in 0..<1000 {
            let a = Self.random
            let b = Self.random
            XCTAssertEqual(a.merging(b), b.merging(a))
        }
    }

    static func testIdempotency() {
        for _ in 0..<1000 {
            let a = Self.random
            XCTAssertEqual(a.merging(a), a)
        }
    }

    static func testAssociativity() {
        for _ in 0..<1000 {
            let a = Self.random
            let b = Self.random
            let c = Self.random
            XCTAssertEqual(a.merging(b).merging(c), a.merging(b.merging(c)))
        }
    }
}
