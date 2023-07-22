import SwiftUI
import Common

struct PostListView: View {
    
    private var store = PostListStore()
    
    @State private var navigationPath = NavigationPath()
    @State private var destination: Destination?
    @Namespace private var animation
    
    enum Destination: Identifiable, Hashable {
        case post(Int)
        
        var id: Int { return hashValue }
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                ForEach(store.rows, id: \.id) { item in
                    NavigationLinkWithoutChevron(value: item.id, label: {
                        PostView(post: item, fullView: false)
                    })
                    .listRowInsets(EdgeInsets([.vertical], size: .small))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden, edges: .all)
                }
            }
            .transition(.opacity)
            .navigationTitle(Text("Lemur"))
            .listStyle(.grouped)
            .navigationDestination(for: Int.self, destination: { postId in
                PostDetailView(id: postId)
            })
        }
        .task {
            try! await store.load()
        }
    }
}

#Preview {
    PostListView()
}
