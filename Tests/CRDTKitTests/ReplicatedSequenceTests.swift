
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

    func testMerge() {

        var siteA = ReplicatedSequence<Character>(site: "SiteA")
        siteA.insert("a", at: 0)
        siteA.insert("b", at: 1)

        var siteB = ReplicatedSequence<Character>(site: "SiteB")
        siteB.merge(siteA)

        XCTAssertEqual(siteA.elements, siteB.elements)

        siteA.insert("c", at: 2)
        siteA.insert("d", at: 3)

        siteB.insert("e", at: 2)
        siteB.insert("f", at: 3)

        siteA.merge(siteB)
        siteB.merge(siteA)

        XCTAssertEqual(siteA.elements, siteB.elements)
        XCTAssertEqual(String(siteA.elements), "abefcd")
    }

    func testLaws() {
        ReplicatedSequence<Int>.testCommutativity(equating: \.elements)
        ReplicatedSequence<Int>.testAssociativity(equating: \.elements)
        ReplicatedSequence<Int>.testIdempotency(equating: \.elements)
    }
}

extension ReplicatedSequence: Randomizable where Element == Int {

    static var random: ReplicatedSequence<Int> {
        let count = Int.random(in: 1...10)
        var sequence = ReplicatedSequence()
        for index in 0...count {
            sequence.insert(Int.random, at: index)
        }
        return sequence
    }
}
