import Foundation
import SwiftUI

public class ViewProvider: ObservableObject {
    public var communityProvider: CommunityViewProvider?
    public var postProvider: PostViewProvider?
    public var settingsProvider: SettingsViewProvider?
    
    
    
    public init() {
        
    }
    
    func showPost(siteUrl: URL, id: Int) {
        
    }
}
