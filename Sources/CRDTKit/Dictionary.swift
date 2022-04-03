
extension Dictionary: CRDT where Value: CRDT {

    public mutating func merge(_ other: Dictionary<Key, Value>) {
        merge(other) { $0.merging($1) }
    }
}
