import Foundation
import SwiftUI

/// Removes extra spacing reserved for section header
/// Use in conjuction with
/// ```
/// .environment(\.defaultMinListHeaderHeight, .zero)
/// ```
public struct SectionWithoutHeader<Content: View>: View {
    
    var content: () -> Content
    
    public init(_ content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        Section {
            content()
        } header: {
            VStack {
                Spacer(minLength: .zero)
            }.listRowInsets(EdgeInsets([.all], size: .zero))
        }
    }
}
