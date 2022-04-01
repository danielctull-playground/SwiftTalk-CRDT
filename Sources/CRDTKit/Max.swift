
public struct Max<Value: Comparable>: Equatable {
    
    public var value: Value
    public init(_ value: Value) {
        self.value = value
    }
}

extension Max: CRDT {

    public mutating func merge(_ other: Self) {
        value = max(value, other.value)
    }
}

extension Max: Decodable where Value: Decodable {}
extension Max: Encodable where Value: Encodable {}
