
public struct LinearSequence<Element> {
    let site: SiteID
    var _elements: [Node] = []
    var clock: Int = 0

    public init(site: SiteID) {
        self.site = site
    }
}

extension LinearSequence {

    public mutating func insert(_ value: Element, at index: Int) {
        let parent = index > 0 ? _elements[index - 1].id : nil
        let id = NodeID(site: site, time: clock)
        let node = Node(parent: parent, id: id, value: value)
        _elements.insert(node, at: index)
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
