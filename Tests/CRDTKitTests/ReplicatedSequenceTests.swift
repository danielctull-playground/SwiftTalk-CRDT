
import CRDTKit
import XCTest

// "hello"
// s1: "hello world"
// s2: "hello beautiful"
// -> "hello beautiful world" ✅
// -> "hello world beautiful" ✅
// -> "hello wboeraludtiful"  ❎

/*
 A tree:

 - hello
   - world
   - beautiful
 */

final class ReplicatedSequenceTests: XCTestCase {

    func test() {
        var sequence = ReplicatedSequence<Character>(site: "SiteA")
        sequence.insert("a", at: 0)
        sequence.insert("b", at: 1)
        sequence.insert("c", at: 1)
        XCTAssertEqual(sequence.elements, ["a", "c", "b"])
    }
}
