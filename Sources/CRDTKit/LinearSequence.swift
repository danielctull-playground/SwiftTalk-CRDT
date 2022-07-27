
public struct LinearSequence<Element> {
    let site: SiteID
    var _elements: [Node] = []
    var clock: Int = 0

    public init(site: SiteID) {
        self.site = site
    }

    public init() {
        self.init(site: SiteID())
    }
}

extension LinearSequence: CRDT {

    public mutating func merge(_ other: LinearSequence<Element>) {
        for node in other._elements {
            _insert(node)
        }
    }

    private mutating func _insert(_ node: Node) {
        let index: Int
        if let parent = node.parent {
            index = _elements.firstIndex(where: { $0.id == parent })! + 1
        } else {
            index = 0
        }
        for existingIndex in _elements[index...].indices {
            let existing = _elements[existingIndex]
            if existing.id == node.id {
                _elements[existingIndex].merge(node)
                return
            }
            if existing.id < node.id {
                _elements.insert(node, at: existingIndex)
                return
            }
        }
        _elements.append(node)
    }
}

extension LinearSequence {

    private var nonDeletedIndices: [Int] {
        _elements.indices.filter { !_elements[$0].deleted }
    }

    public mutating func remove(at index: Int) {
        let nonDeletedIndices = _elements.indices.filter { !_elements[$0].deleted }
        _elements[nonDeletedIndices[index]].deleted = true
    }

    public mutating func insert(_ value: Element, at index: Int) {
        let parent = index > 0
            ? _elements[nonDeletedIndices[index - 1]].id
            : nil
        let id = NodeID(site: site, time: clock)
        let node = Node(parent: parent, id: id, value: value)
        _insert(node)
        clock += 1
    }

    public var elements: [Element] { Array(self) }
}

extension LinearSequence: Collection {

    public struct Index: Comparable {
        fileprivate let internalIndex: Int
        public static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.internalIndex < rhs.internalIndex
        }
    }

    public var startIndex: Index {

        guard let index = _elements.firstIndex(where: { !$0.deleted }) else {
            return endIndex
        }

        return Index(internalIndex: index)
    }

    public var endIndex: Index {
        Index(internalIndex: _elements.endIndex)
    }

    public func index(after i: Index) -> Index {
        if let index = _elements[(i.internalIndex + 1)...].firstIndex(where: { !$0.deleted }) {
            return Index(internalIndex: index)
        } else {
            return endIndex
        }
    }

    public subscript(position: Index) -> Element {
        _elements[position.internalIndex].value
    }
}

extension LinearSequence: BidirectionalCollection {

    public func index(before i: Index) -> Index {
        if let index = _elements[..<i.internalIndex].lastIndex(where: { !$0.deleted }) {
            return Index(internalIndex: index)
        } else {
            return startIndex
        }
    }
}

extension LinearSequence: RandomAccessCollection {}

// MARK: - Node

extension LinearSequence {

    struct Node {
        let parent: NodeID?
        let id: NodeID
        let value: Element
        var deleted = false
    }
}

extension LinearSequence.Node {

    fileprivate mutating func merge(_ other: Self) {
        assert(parent == other.parent)
        assert(id == other.id)
        deleted = deleted || other.deleted
    }
}
