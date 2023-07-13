import SwiftUI
import Common
import Observation

@Observable
class MainStore: ObservableObject {
    
}

struct MainView: View {
    @StateObject private var store = MainStore()
    
    @EnvironmentObject private var provider: ViewProvider
    
    var body: some View {
        provider.postProvider?.listView()
    }
}

#Preview {
    MainView()
}
