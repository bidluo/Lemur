import Foundation
import SwiftUI
import Common

public class ViewProvider: PostViewProvider {
    public func listView() -> AnyView {
        return AnyView(PostListView(siteUrl: nil, communityId: nil))
    }
    
    public func listView(siteUrl: URL?, communityId: Int?) -> AnyView {
        return AnyView(PostListView(siteUrl: siteUrl, communityId: communityId))
    }
    
    public init() {
        
    }
}
