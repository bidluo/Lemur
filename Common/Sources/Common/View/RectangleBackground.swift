import Foundation
import SwiftUI

public struct RectangleBackground: View {
    
    public init() {
        
    }
    
    public var body: some View {
        RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
            .fill(Colour.secondaryBackground.swiftUIColor)
    }
}
