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
            .listSectionSpacing(.compact)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Menu(content: {
                        ForEach(store.mainItems, id: \.self) { item in
                            Button(action: { store.selectedSort = item }, label: { Text(item.rawValue) })
                        }
                        
                        Menu(content: {
                            ForEach(store.topItems, id: \.self) { item in
                                Button(action: { store.selectedSort = item }, label: { Text(item.rawValue) })
                            }
                        }, label: {
                            Text("Top...")
                        })
                        
                        Menu(content: {
                            ForEach(store.commentItems, id: \.self) { item in
                                Button(action: { store.selectedSort = item }, label: { Text(item.rawValue) })
                            }
                        }, label: {
                            Text("Comments...")
                        })
                    }, label: {
                        switch store.selectedSort {
                        case .hot: Image(systemName: "flame.fill")
                        case .active: Image(systemName: "bolt.fill")
                        case .new: Image(systemName: "hourglass.tophalf.filled")
                        case .old: Image(systemName: "hourglass.bottomhalf.filled")
                        case .mostComments, .newComments: Image(systemName: "bubble.left.and.bubble.right.fill")
                        default: Image(systemName: "crown.fill")
                        }
                    })
                })
            }
            .transition(.opacity)
            .navigationTitle(Text("Lemur"))
            .listStyle(.grouped)
            .navigationDestination(for: Int.self, destination: { postId in
                PostDetailView(id: postId)
            })
        }
        .onChange(of: store.selectedSort, { old, new in
            if old != new {
                Task {
                    try! await store.load()
                }
            }
        })
        .task {
            try! await store.load()
        }
    }
}

#Preview {
    PostListView()
}
