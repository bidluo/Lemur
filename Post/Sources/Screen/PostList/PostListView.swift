import SwiftUI
import Common

struct PostListView: View {
    
    private var store = PostListStore()
    private var errorHandler = ErrorHandling()
    
    @State private var navigationPath = NavigationPath()
    @Namespace private var animation
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                ForEach(store.rows, id: \.id) { item in
                    NavigationLinkWithoutChevron(value: item, label: {
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
            .navigationDestination(for: PostSummary.self, destination: { post in
                PostDetailView(siteUrl: post.siteUrl, id: post.id)
            })
        }
        .task(id: store.selectedSort) {
            executing(action: store.reload, errorHandler: errorHandler)
        }
        .task {
            executing(action: store.reload, errorHandler: errorHandler)
        }
    }
}

#Preview {
    PostListView()
}
