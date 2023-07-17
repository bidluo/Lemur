import Foundation
import SwiftUI

// Hides the chevron when using a NavigationLink inside a Section/List
public struct NavigationLinkWithoutChevron<Value: Hashable, Label: View>: View {
    
    private var value: Value?
    private var label: () -> Label
    
    public init(value: Value? = nil, label: @escaping () -> Label) {
        self.value = value
        self.label = label
    }
    
    public var body: some View {
        label()
            .overlay {
                NavigationLink(value: value, label: {
                    EmptyView()
                })
                .buttonStyle(.borderless)
                .frame(width: 0)
                .opacity(0)
            }
    }
}
