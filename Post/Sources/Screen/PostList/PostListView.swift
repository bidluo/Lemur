import SwiftUI
import Common

public struct PostListView: View {
    
    @State private var store: PostListStore
    @State private var errorHandler = ErrorHandling()
    
    public init(siteUrl: URL? = nil, communityId: Int? = nil) {
        self._store = State(wrappedValue: PostListStore(siteUrl: siteUrl, communityId: communityId))
    }
    
    public var body: some View {
        List {
            ForEach(store.rows, id: \.self) { item in
                NavigationLinkWithoutChevron(value: item, label: {
                    PostView(post: item, fullView: false)
                })
                .listRowInsets(EdgeInsets([.vertical], size: .small))
                .listRowSeparator(.hidden, edges: .all)
                .task {
                    if item.id == store.lastRowId {
                        await executingTask(action: store.loadNextPage, errorHandler: errorHandler)
                    }
                }
            }
        }
        .listRowSpacing(Size.smallMedium.rawValue)
        .listSectionSpacing(.compact)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Menu(content: {
                    ForEach(store.mainItems, id: \.self) { item in
                        Button(action: { 
                            store.selectedSort = item
                            executing(action: store.reload, errorHandler: errorHandler)
                        }, label: { Text(item.rawValue) })
                    }
                    
                    Menu(content: {
                        ForEach(store.topItems, id: \.self) { item in
                            Button(action: { 
                                store.selectedSort = item
                            executing(action: store.reload, errorHandler: errorHandler)
                            }, label: { Text(item.rawValue) })
                        }
                    }, label: {
                        Text("Top...")
                    })
                    
                    Menu(content: {
                        ForEach(store.commentItems, id: \.self) { item in
                            Button(action: {
                                store.selectedSort = item
                                executing(action: store.reload, errorHandler: errorHandler)
                            }, label: { Text(item.rawValue) })
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
        .task {
            await executingTask(action: { try await store.load() }, errorHandler: errorHandler)
        }
        .transaction { transaction in
            transaction.dismissBehavior = .interactive
        }
    }
}

#Preview {
    PostListView(siteUrl: nil, communityId: nil)
}
