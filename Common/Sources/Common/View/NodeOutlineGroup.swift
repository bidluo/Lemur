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
    let content: (Node, Int, Bool) -> Content
    
    public init(
        node: Node,
        children: KeyPath<Node, [Node]?>,
        nestLevel: Int,
        content: @escaping (Node, Int, Bool) -> Content
    ) {
        self.node = node
        self.children = children
        self.content = content
        self.nestLevel = nestLevel
    }
    
    public var body: some View {
            DisclosureGroup(
                isExpanded: $isExpanded,
                content: {
                    if let nodeChildren = node[keyPath: children], isExpanded {
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
                    content(node, nestLevel, isExpanded)
                })
    }
}
