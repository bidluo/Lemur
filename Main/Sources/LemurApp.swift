import SwiftUI
import Common
import Community
import Post
import Setting

@main
struct LemurApp: App {
    
    private let provider: Common.ViewProvider
    
    init() {
        provider = ViewProvider()
        provider.communityProvider = Community.ViewProvider()
        provider.postProvider = Post.ViewProvider()
        provider.settingsProvider = Setting.ViewProvider()
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(provider)
        }
    }
}
