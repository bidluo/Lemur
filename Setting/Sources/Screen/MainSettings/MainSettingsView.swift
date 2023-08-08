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
                
                // Signout button
            }
        }
        .sheet(item: $store.presentedSheet, content: { sheet in
            switch sheet {
            case .addServer:
                ServerAddView()
                    .accentColor(Colour.brandPrimary.swiftUIColor)
                    .presentationDetents([.medium, .large])
                
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
