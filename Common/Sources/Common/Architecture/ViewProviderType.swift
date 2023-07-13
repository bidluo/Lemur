import Foundation
import SwiftUI

public class ViewProvider: ObservableObject {
    public var communityProvider: CommunityViewProvider?
    public var postProvider: PostViewProvider?
    
    public init() {
        
    }
}
