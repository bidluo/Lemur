import Foundation
import SwiftUI
import Common

public class ViewProvider: CommunityViewProvider {
    public func listView() -> AnyView {
        return AnyView(CommunityListView())
    }
    
    public init() {
        
    }
}
