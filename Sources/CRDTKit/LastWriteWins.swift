
public struct LastWriteWins<Value>: CRDT {

    private var site: SiteID
    private var clock = 0

    public init(site: SiteID, _ value: Value) {
        self.site = site
        self.value = value
    }


    public var value: Value {
        didSet { clock += 1 }
    }

    public mutating func merge(_ other: LastWriteWins<Value>) {
        guard (other.clock, other.site) > (clock, site) else { return }
        value = other.value
        clock = other.clock
    }
}

extension LastWriteWins: Decodable where Value: Decodable {}
extension LastWriteWins: Encodable where Value: Encodable {}
extension LastWriteWins: Equatable where Value: Equatable {}
extension LastWriteWins: Hashable where Value: Hashable {}
