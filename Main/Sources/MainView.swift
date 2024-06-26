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
    var authenticated: Bool = true
}

struct MainView: View {
    @State private var store = MainStore()
    @State private var serversChangedNotifier = ServersChangedNotifier()
    @EnvironmentObject private var provider: Common.ViewProvider
    
    @State private var postListId = UUID()
    
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
                    provider.postProvider?.listView()
                        .environment(\.authenticated, store.authenticated)
                        .id(postListId)
                }, detail: {
                }
            )
            .navigationSplitViewStyle(.balanced)
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            
            provider.communityProvider?.listView()
                .tabItem {
                    Image(systemName: "square.grid.3x2.fill")
                    Text("Communities")
                }
            
            provider.settingsProvider?.mainSettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        .accentColor(Colour.brandPrimary.swiftUIColor)
        .sheet(item: $store.activeSheet, content: { sheet in
            switch sheet {
            case .signin: provider.settingsProvider?.signInView()
            }
        })
        .environmentObject(serversChangedNotifier)
        .serversChanged(notifier: serversChangedNotifier) {
            postListId = UUID()
        }
    }
}

#Preview {
    MainView()
}
