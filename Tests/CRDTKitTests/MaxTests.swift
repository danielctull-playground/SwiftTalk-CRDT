
import CRDTKit
import XCTest

final class MaxTests: XCTestCase {
    
    func test() {
        for _ in 0..<1000 {
            let a = Max(value: Int.random)
            let b = Max(value: Int.random)
            XCTAssertEqual(a.merging(b), b.merging(a))
        }
    }
}

extension Int {
    
    fileprivate static var random: Int {
        .random(in: Int.min..<Int.max)
    }
}
