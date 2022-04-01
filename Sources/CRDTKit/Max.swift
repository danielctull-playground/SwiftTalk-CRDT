
public struct Max<Value: Comparable>: Equatable {
    
    public var value: Value
    public init(_ value: Value) {
        self.value = value
    }
    
    public mutating func merge(_ other: Self) {
        self = merging(other)
    }
    
    public func merging(_ other: Self) -> Self {
        Self(max(value, other.value))
    }
}

extension Max: Decodable where Value: Decodable {}
extension Max: Encodable where Value: Encodable {}
