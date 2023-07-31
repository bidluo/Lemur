import SwiftUI
import Common

public struct MainSettingsView: View {

    private var store = MainSettingsStore()
    
    @State private var navigationPath = NavigationPath()
    
    public init() {
        
    }
    
    public var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                
                // Signout button
            }
        }
        .sheet(isPresented: .constant(true), content: {
            ServerAddView()
                .presentationDetents([.medium])
        })
        .task {
            try? await store.load()
        }
    }
}

#Preview {
    MainSettingsView()
}
