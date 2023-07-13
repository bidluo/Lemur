import Foundation
import SwiftUI
import Common

public class ViewProvider: PostViewProvider {
    public func listView() -> AnyView {
        return AnyView(PostListView())
    }
    
    public init() {
        
    }
}
