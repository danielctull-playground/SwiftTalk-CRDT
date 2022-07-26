
import Foundation

public struct SiteID: Equatable, Hashable, Codable {
    private let rawValue: String

    init() {
        rawValue = UUID().uuidString
    }
}

extension SiteID: Comparable {

    public static func < (lhs: SiteID, rhs: SiteID) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension SiteID: ExpressibleByStringLiteral {

    public init(stringLiteral: String) {
        rawValue = stringLiteral
    }
}

public struct GrowOnlyCounter<Value: Comparable & AdditiveArithmetic>: Equatable {

    private var storage: [SiteID: Max<Value>]
    private var site = SiteID()

    public init(_ value: Value) {
        self.storage = [site: Max(value)]
    }

    public var value: Value {
        storage.values.reduce(.zero) { $0 + $1.value }
    }

    public static func +=(lhs: inout Self, rhs: Value) {
        assert(rhs >= .zero, "GrowOnlyCounter cannot be decremented")
        lhs.storage[lhs.site, default: Max(.zero)].value += rhs
    }
}

extension GrowOnlyCounter: CRDT {

    public mutating func merge(_ other: Self) {
        storage.merge(other.storage) { $0.merging($1) }
    }
}

extension GrowOnlyCounter: Decodable where Value: Decodable {}
extension GrowOnlyCounter: Encodable where Value: Encodable {}
