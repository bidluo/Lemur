import Foundation
import SwiftUI

public extension LabelStyle {
}

public extension LabelStyle where Self == SpacingLabelStyle {
    
    static func spacing(_ spacing: Double) -> SpacingLabelStyle {
        SpacingLabelStyle(spacing: spacing)
    }
}

public struct SpacingLabelStyle: LabelStyle {
    var spacing: Double = 0.0
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: spacing) {
            configuration.icon
            configuration.title
        }
    }
}
