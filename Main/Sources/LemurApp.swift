import SwiftUI
import Common
import Community

@main
struct LemurApp: App {
    
    private let provider: Common.ViewProvider
    
    init() {
        provider = ViewProvider()
        provider.communityProvider = Community.ViewProvider()
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(provider)
        }
    }
}
