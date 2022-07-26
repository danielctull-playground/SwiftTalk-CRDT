
import CRDTKit
import XCTest

final class LinearSequenceTests: XCTestCase {

    func testInsert() {
        for _ in 0...1000 {
            var sequence = LinearSequence<Int>(site: "SiteA")
            var array = Array<Int>()
            for _ in 1...Int.random(in: 1...10) {
                let index = Int.random(in: 0...array.count)
                let value = Int.random
                sequence.insert(value, at: index)
                array.insert(value, at: index)
                XCTAssertEqual(sequence.elements, array)
            }
        }
    }
}
