
import CRDTKit
import XCTest

final class MaxTests: XCTestCase {
    
    func test() {
        var a = Max(value: 1)
        let b = Max(value: 2)
        a.merge(b)
        XCTAssertEqual(a.merging(b), b.merging(a))
    }
}
