import SwiftUI
import Common
import Observation
import Post
import Community

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
    @EnvironmentObject private var provider: Common.ViewProvider
    
    var body: some View {
        TabView {
            NavigationSplitView(
                columnVisibility: .constant(.doubleColumn),
                preferredCompactColumn: .constant(.content),
                sidebar: {
                    MainSideBarView()
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
                }, content: {
                    PostListView()
                }, detail: {
                }
            )
            .navigationSplitViewStyle(.balanced)

            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            
            provider.settingsProvider?.mainSettingsView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Settings")
                }
            
            provider.communityProvider?.listView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("house.fill")
                }
        }
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
