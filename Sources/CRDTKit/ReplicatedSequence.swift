
public struct ReplicatedSequence<Element> {

    private let site: SiteID
    var root: [Node] = []
    var clock = 0

    public init(site: SiteID) {
        self.site = site
    }

    public init() {
        self.init(site: SiteID())
    }
}

extension ReplicatedSequence: Equatable where Element: Equatable {}

extension ReplicatedSequence: CRDT {

    public mutating func merge(_ other: Self) {
        root.merge(other: other.root)
        clock = Swift.max(clock, other.clock)
    }
}

extension ReplicatedSequence {

    public mutating func insert(_ value: Element, at index: Int) {
        let node = Node(id: NodeID(site: site, time: clock), value: value)
        if index == 0 {
            root.insert(node, at: 0)
        } else {
            let all = Array(self)
            let parent = all[index-1]
            for i in root.indices {
                root[i].insert(node, after: parent.id)
            }
        }
        clock += 1
    }

    public var elements: [Element] {
        map { $0.value }
    }
}

extension ReplicatedSequence: Sequence {

    public func makeIterator() -> AnyIterator<Node> {
        var remainder = root

        return AnyIterator {
            guard !remainder.isEmpty else { return nil }
            let result = remainder.removeFirst()
            remainder.insert(contentsOf: result.children, at: 0)
            return result
        }
    }
}

// MARK: - NodeID

struct NodeID: Equatable {
    let site: SiteID
    let time: Int
}

extension NodeID: Comparable {

    static func < (lhs: NodeID, rhs: NodeID) -> Bool {
        (lhs.time, lhs.site) < (rhs.time, rhs.site)
    }
}

extension NodeID: Decodable {}
extension NodeID: Encodable {}
extension NodeID: Hashable {}

// MARK: - Node

extension ReplicatedSequence {

    public struct Node {
        let id: NodeID
        let value: Element
        var children: [Node] = []
    }
}

extension ReplicatedSequence.Node: Equatable where Element: Equatable {}

extension ReplicatedSequence.Node: CRDT {

    public mutating func merge(_ other: Self) {
        assert(id == other.id)
        children.merge(other: other.children)
    }
}

extension ReplicatedSequence.Node {

    mutating func insert(_ node: Self, after parent: NodeID) {
        if id == parent {
            children.insert(node, at: 0)
        } else {
            for i in children.indices {
                children[i].insert(node, after: parent)
            }
        }
    }
}

extension Array {

    mutating func merge<Value>(
        other: [ReplicatedSequence<Value>.Node]
    ) where Element == ReplicatedSequence<Value>.Node {

        for element in other {
            if let index = firstIndex(where: { $0.id == element.id }) {
                self[index].merge(element)
            } else {
                append(element)
            }
        }
        sort(by: { $0.id > $1.id })
    }
}
