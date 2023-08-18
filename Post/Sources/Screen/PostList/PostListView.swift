import SwiftUI
import Common

public struct PostListView: View {
    
    @State private var store: PostListStore
    @State private var errorHandler = ErrorHandling()
    
    public init(siteUrl: URL? = nil, communityId: Int? = nil) {
        self._store = State(wrappedValue: PostListStore(siteUrl: siteUrl, communityId: communityId))
    }
    
    public var body: some View {
//        NavigationStack(path: $navigationPath) {
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
                .id(post.id)
        })
//        .task(id: store.selectedSort) {
//            executing(action: store.reload, errorHandler: errorHandler)
//        }
        .task {
            executing(action: store.load, errorHandler: errorHandler)
        }
        .transaction { transaction in
            transaction.dismissBehavior = .interactive
        }
    }
}

#Preview {
    PostListView(siteUrl: nil, communityId: nil)
}
