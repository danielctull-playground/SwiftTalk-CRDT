
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
                // TODO: Safety checks
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

    public mutating func insert(_ value: Element, at index: Int) {
        let parent = index > 0 ? _elements[index - 1].id : nil
        let id = NodeID(site: site, time: clock)
        let node = Node(parent: parent, id: id, value: value)
        _insert(node)
        clock += 1
    }

    public var elements: [Element] {
        _elements.map(\.value)
    }
}

// MARK: - Node

extension LinearSequence {

    struct Node {
        let parent: NodeID?
        let id: NodeID
        let value: Element
    }
}