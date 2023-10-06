import Foundation
import SwiftUI
import Common

struct PostDetailView: View {
    
    @State private var store: PostDetailStore
    @State private var errorHandler = ErrorHandling()
    @State private var composePresentedForComment: Int?
    @State private var presentedSheet: PresentedSheet?
    private let id: Int
    
    private enum PresentedSheet: Identifiable, Hashable {
        case composeComment(CommentContent)
        
        
        var id: Int { return hashValue }
    }
    
    init(siteUrl: URL, id: Int) {
        self.id = id
        self._store = State(wrappedValue: PostDetailStore(siteUrl: siteUrl, id: id))
    }
    
    var body: some View {
        List {
            if let _post = store.post {
                SectionWithoutHeader {
                    PostView(post: _post, fullView: true)
                        .listRowInsets(EdgeInsets(.all, size: .zero))
                        .listRowSeparator(.hidden, edges: .all)
                }
            }
            
            NodeListOutlineGroup(store.comments, children: \.children) { comment, nestLevel in
                CommentView(comment: comment, siteUrl: store.siteUrl, nestLevel: nestLevel)
                    .replyTapped { comment in
                        presentedSheet = .composeComment(comment)
                    }
            }
            .disclosureGroupStyle(.arrowLess)
            .listRowInsets(EdgeInsets(.all, size: .zero))
        }
        .navigationBarTitleDisplayMode(.inline)
        .listSectionSpacing(.compact)
        .listStyle(.grouped)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Menu(content: {
                    ForEach(store.sortItems, id: \.self) { item in
                        Button(action: { store.selectedSort = item }, label: { Text(item.rawValue) })
                    }
                }, label: {
                    switch store.selectedSort {
                    case .hot: Image(systemName: "flame.fill")
                    case .top: Image(systemName: "crown.fill")
                    case .new: Image(systemName: "hourglass.tophalf.filled")
                    case .old: Image(systemName: "hourglass.bottomhalf.filled")
                    }
                })
            })
        }
        .withErrorHandling(errorHandling: errorHandler)
        .task(id: store.selectedSort, {
            await executingTask(action: store.loadComments, errorHandler: errorHandler)
        })
        .task {
            await executingTask(action: store.load, errorHandler: errorHandler)
        }
        .sheet(item: $presentedSheet, content: { sheet in
            switch sheet {
            case let .composeComment(comment):
                CommentComposeView(siteUrl: store.siteUrl, postId: id, parentId: comment.id)
                    .onDisappear {
                        // TODO: Load locally instead of remote
                        executing(action: store.loadComments, errorHandler: errorHandler)
                    }
            }
        })
    }
}
