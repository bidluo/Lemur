import SwiftUI
import Common

public struct MainSettingsView: View {

    @State private var store = MainSettingsStore()
    @State private var navigationPath = NavigationPath()
    
    public init() {
        
    }
    
    public var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                Section {
                    ForEach(store.sites, id: \.name) { site in
                        VStack(alignment: .leading) {
                            Text(site.name).font(.subheadingBold)
                            Text(site.urlString).font(.footnote)
                        }
                    }
                    
                    Button(action: {
                        store.presentedSheet = .addServer
                    }, label: {
                        Text("Add server")
                    })
                } header: {
                    Text("Servers")
                }
                
                Section {
                    ForEach(store.loggedInUsers, id: \.id) { user in
                        VStack(alignment: .leading) {
                            Text(user.name ?? "").font(.subheadingBold)
                            Text(user.siteName ?? "").font(.footnote)
                        }
                    }
                    
                    Button(action: {
                        store.presentedSheet = .signIn
                    }, label: {
                        Text("Add user")
                    })
                } header: {
                    Text("Logged in users")
                }
            }
        }
        .sheet(item: $store.presentedSheet, content: { sheet in
            switch sheet {
            case .addServer:
                ServerAddView()
                    .accentColor(Colour.brandPrimary.swiftUIColor)
                    .presentationDetents([.medium, .large])
            case .signIn:
                SignInView()
                    .accentColor(Colour.brandPrimary.swiftUIColor)
            }
        })
        .task {
            try? await store.load()
        }
    }
}

#Preview {
    MainSettingsView()
}
