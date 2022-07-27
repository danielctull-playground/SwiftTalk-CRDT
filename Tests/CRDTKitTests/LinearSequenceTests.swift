
import CRDTKit
import XCTest

final class LinearSequenceTests: XCTestCase {

    func testSingleSite() {
        for _ in 0...1000 {
            var sequence = LinearSequence<Int>(site: "SiteA")
            var array = Array<Int>()
            for _ in 1...Int.random(in: 1...10) {
                if let index = array.indices.randomElement(), Int.random(in: 1...4) == 1 {
                    sequence.remove(at: index)
                    array.remove(at: index)
                } else {
                    let index = Int.random(in: 0...array.count)
                    let value = Int.random
                    sequence.insert(value, at: index)
                    array.insert(value, at: index)
                }
                XCTAssertEqual(sequence.elements, array)
            }
        }
    }

    func testMerge() {

        var siteA = LinearSequence<Character>(site: "SiteA")
        siteA.insert("a", at: 0)
        siteA.insert("b", at: 1)

        var siteB = LinearSequence<Character>(site: "SiteB")
        siteB.merge(siteA)

        XCTAssertEqual(siteA.elements, siteB.elements)

        siteA.insert("c", at: 2)
        siteA.insert("d", at: 3)

        siteB.insert("e", at: 2)
        siteB.insert("f", at: 3)

        siteA.merge(siteB)
        siteB.merge(siteA)

        XCTAssertEqual(siteA.elements, siteB.elements)
        XCTAssertEqual(String(siteA.elements), "abcdef")
    }

    func testLaws() {
        LinearSequence<Int>.testCommutativity(equating: \.elements)
        LinearSequence<Int>.testAssociativity(equating: \.elements)
        LinearSequence<Int>.testIdempotency(equating: \.elements)
    }
}

extension LinearSequence: Randomizable where Element == Int {

    static var random: LinearSequence<Int> {
        let count = Int.random(in: 1...10)
        var sequence = LinearSequence()
        for index in 0...count {
            sequence.insert(Int.random, at: index)
        }
        return sequence
    }
}
