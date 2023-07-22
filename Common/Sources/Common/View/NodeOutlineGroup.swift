import Foundation
import SwiftUI

/// Replica of OutlineGroup that defaults `isExpanded` to true.
/// Also adds functionality to pass content block the level of nesting.
/// This replica takes a single node as an argument, see `NodeListOutlineGroup` for a list of Nodes.
public struct NodeOutlineGroup<Node, Content>: View where Node: Hashable, Node: Identifiable, Content: View {
    @State var isExpanded: Bool = true
    
    let node: Node
    let children: KeyPath<Node, [Node]?>
    let nestLevel: Int
    let content: (Node, Int) -> Content
    
    public init(
        node: Node,
        children: KeyPath<Node, [Node]?>,
        nestLevel: Int,
        content: @escaping (Node, Int) -> Content
    ) {
        self.node = node
        self.children = children
        self.content = content
        self.nestLevel = nestLevel
    }
    
    public var body: some View {
        if let nodeChildren = node[keyPath: children] {
            DisclosureGroup(
                isExpanded: $isExpanded,
                content: {
                    if isExpanded {
                        ForEach(nodeChildren, id: \.self) { childNode in
                            NodeOutlineGroup(
                                node: childNode,
                                children: children,
                                nestLevel: nestLevel + 1,
                                content: content
                            )
                        }
                    }
                },
                label: {
                    content(node, nestLevel)
                })
        } else {
            content(node, nestLevel)
        }
    }
}

public struct NodeListOutlineGroup<Node, Content>: View where Node: Hashable, Node: Identifiable, Content: View {
    let nodes: [Node]
    let children: KeyPath<Node, [Node]?>
    let content: (Node, Int) -> Content
    
    public init(_ nodes: [Node], children: KeyPath<Node, [Node]?>, content: @escaping (Node, Int) -> Content) {
        self.nodes = nodes
        self.children = children
        self.content = content
    }
    
    public var body: some View {
        ForEach(nodes) { node in
            NodeOutlineGroup(node: node, children: children, nestLevel: 0, content: content)
        }
    }
}
