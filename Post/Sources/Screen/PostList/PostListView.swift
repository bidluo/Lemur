import SwiftUI
import Common

public struct PostListView: View {
    
    private var store = PostListStore()
    
    @State private var navigationPath = NavigationPath()
    
    public init() {
        
    }
    
    public var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                ForEach(store.rows, id: \.self) { item in
                    Text(item)
                }
            }
            .listStyle(.plain)
        }
        .task {
            try? await store.load()
        }
    }
}

#Preview {
    PostListView()
}
