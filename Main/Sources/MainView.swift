import SwiftUI
import Common
import Observation

@Observable
class MainStore {
    enum PresentedSheet: Identifiable, Hashable {
        case signin
        
        var id: Int { return hashValue }
    }
    
    var activeSheet: PresentedSheet?
}

struct MainView: View {
    @State private var store = MainStore()
    @EnvironmentObject private var provider: ViewProvider
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.detailOnly), preferredCompactColumn: .constant(.detail), sidebar: {
            Text("Community List")
                .toolbar {
                    Button(action: {
                        store.activeSheet = .signin
                    }, label: {
                        Image(systemName: "person.circle.fill")
                    })
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Communities")
                    }
                }
        }, detail: {
            TabView {
                provider.postProvider?.listView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                
                provider.settingsProvider?.mainSettingsView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Settings")
                    }
            }
        })
        .accentColor(Colour.brandPrimary.swiftUIColor)
        .sheet(item: $store.activeSheet, content: { sheet in
            switch sheet {
            case .signin: provider.settingsProvider?.signInView()
            }
        })
    }
}

#Preview {
    MainView()
}
