
public struct ReplicatedSequence<Value> {

    private let site: SiteID
    var root: [Node<Value>] = []
    var clock = 0

    public init(site: SiteID) {
        self.site = site
    }
}

extension ReplicatedSequence {

    public mutating func insert(_ value: Value, at index: Int) {
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

    public var elements: [Value] {
        map { $0.value }
    }
}

extension ReplicatedSequence: Sequence {

    public func makeIterator() -> AnyIterator<Node<Value>> {
        var remainder = root

        return AnyIterator {
            guard !remainder.isEmpty else { return nil }
            let result = remainder.removeFirst()
            remainder.insert(contentsOf: result.children, at: 0)
            return result
        }
    }
}

struct NodeID: Equatable {
    let site: SiteID
    let time: Int
}


public struct Node<Value> {
    let id: NodeID
    let value: Value
    var children: [Node<Value>] = []
}

extension Node {

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
