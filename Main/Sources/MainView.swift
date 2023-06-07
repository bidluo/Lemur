import SwiftUI
import Common
import Observation

@Observable
class MainStore: ObservableObject {
    
}

struct MainView: View {
    @StateObject private var store = MainStore()
    
    @State private var activeDestination: Destination?
    @State private var selectedTab: SelectedTab = .one
    @State private var navigationPath = NavigationPath()
    
    @State private var firstTabId = UUID()
    
    @EnvironmentObject private var provider: ViewProvider
    
    enum Destination: Hashable {
        case firstScreen
    }
    
    enum SelectedTab {
        case one, two
    }
    
    var body: some View {
        provider.communityProvider?.listView()
    }
}

#Preview {
    MainView()
}
