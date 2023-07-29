import Foundation
import SwiftUI
import Common

struct PostDetailView: View {
    
    private var store: PostDetailStore
    private let id: Int
    
    init(id: Int) {
        self.id = id
        self.store = PostDetailStore(id: id)
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
                CommentView(comment: comment, nestLevel: nestLevel)
            }
            .disclosureGroupStyle(.arrowLess)
            .listRowInsets(EdgeInsets(.all, size: .zero))
        }
        .navigationBarTitleDisplayMode(.inline)
        .environment(\.defaultMinListHeaderHeight, .zero)
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
        .onChange(of: store.selectedSort, { old, new in
            if new != old {
                Task {
                    try? await store.loadComments()
                }
            }
        })
        .task {
            try? await store.load()
        }
    }
}
