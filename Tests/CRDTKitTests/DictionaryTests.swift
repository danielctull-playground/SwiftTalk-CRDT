
import CRDTKit
import XCTest

extension Dictionary: Randomizable where Key: Randomizable, Value: Randomizable {

    static var random: Self {
        var dictionary: Self = [:]
        for _ in 0..<100 {
            dictionary[.random] = .random
        }
        return dictionary
    }
}

final class DictionaryTests: XCTestCase {

    func testLaws() {
        Dictionary<Int, Max<Int>>.testCommutativity()
        Dictionary<Int, Max<Int>>.testAssociativity()
        Dictionary<Int, Max<Int>>.testIdempotency()
    }
}
