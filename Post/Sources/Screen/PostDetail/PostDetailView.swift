import Foundation
import SwiftUI
import Common

struct PostDetailView: View {
    @State private var store: PostDetailStore
    @State private var errorHandler = ErrorHandling()
    @State private var composePresentedForComment: Int?
    @State private var presentedSheet: PresentedSheet?
    @State private var presentationDetent: PresentationDetent = .fraction(0.8)
    private let id: Int
    
    private enum PresentedSheet: Identifiable, Hashable {
        case composeComment(CommentContent, Int)
        
        var id: Int { return hashValue }
    }
    
    init(siteUrl: URL, id: Int) {
        self.id = id
        self._store = State(wrappedValue: PostDetailStore(siteUrl: siteUrl, id: id))
    }
    
    var body: some View {
        GeometryReader { proxy in
            List {
                if let _post = store.post {
                    SectionWithoutHeader {
                        PostView(post: _post, fullView: true, width: proxy.size.width)
                            .listRowInsets(EdgeInsets(.all, size: .zero))
                            .listRowSeparator(.hidden, edges: .all)
                    }
                }
                
                ForEach(store.comments) { parent in
                    SectionWithoutHeader {
                        NodeOutlineGroup(
                            node: parent,
                            children: \.children,
                            nestLevel: 0,
                            content: {
                                comment, nestLevel, isExpanded in
                                CommentView(comment: comment, siteUrl: store.siteUrl, nestLevel: nestLevel, expanded: isExpanded)
                                    .replyTapped { comment in
                                        presentedSheet = .composeComment(comment, nestLevel)
                                    }
                            })
                    }
                    .disclosureGroupStyle(.arrowLess)
                    .listRowInsets(EdgeInsets(.all, size: .zero))
                    .listRowSeparator(.hidden)
                }
            }
            .safeAreaInset(edge: .bottom, content: {
                if store.pendingComments.isEmpty == false {
                    Button(action: {
                        store.setNewComments()
                    }, label: {
                        Text(PostStrings.PostDetail.LoadMoreComments)
                    })
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 20))
                    .padding(.small)
                }
            })
            .environment(\.defaultMinListHeaderHeight, .zero)
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
                case let .composeComment(comment, nestLevel):
                    CommentComposeView(siteUrl: store.siteUrl, postId: id, parentComment: comment, nestLevel: nestLevel)
                        .presentationDetents([.fraction(0.3), .fraction(0.8), .large], selection: $presentationDetent)
                        .presentationBackgroundInteraction(
                            .enabled(upThrough: .fraction(0.3))
                        )
                        .onAppear {
                            presentationDetent = .fraction(0.6)
                        }
                        .onDisappear {
                            // TODO: Load locally instead of remote
                            executing(action: store.loadComments, errorHandler: errorHandler)
                        }
                }
            })
        }
    }
}
