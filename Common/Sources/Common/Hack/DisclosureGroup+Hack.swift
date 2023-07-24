import Foundation
import SwiftUI

public struct ArrowLessDisclosureGroupStyle: DisclosureGroupStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.easeInOut) {
                    configuration.isExpanded.toggle()
                }
            }
        
        if configuration.isExpanded {
            configuration.content
                .disclosureGroupStyle(self)
        }
    }
}

extension DisclosureGroupStyle where Self == ArrowLessDisclosureGroupStyle {
    public static var arrowLess: ArrowLessDisclosureGroupStyle { return ArrowLessDisclosureGroupStyle() }
}
