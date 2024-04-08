import Foundation
import Common
import SwiftUI
import MarkdownUI

struct CommentComposeView: View {
    @State private var store: CommentComposeStore
    @State private var errorHandling = ErrorHandling()
    @State private var selectedSegment: Segment = .parent
    private let parentContent: CommentContent
    private let nestLevel: Int
    
    private enum Segment: String, CaseIterable {
        case preview, parent
    }
    
    @Environment(\.dismiss) private var dismissAction
    
    init(
        siteUrl: URL,
        postId: Int,
        parentComment: CommentContent,
        nestLevel: Int
    ) {
        self._store = State(
            wrappedValue: CommentComposeStore(
                siteUrl: siteUrl,
                postId: postId,
                parentId: parentComment.id
            )
        )
        self.parentContent = parentComment
        self.nestLevel = nestLevel
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: .zero) {
                CommentView(
                    comment: parentContent,
                    siteUrl: .applicationDirectory,
                    nestLevel: nestLevel,
                    expanded: true,
                    scrollsContent: true
                )
                .frame(maxHeight: 250)
                
                Divider()
                    .padding(.leading, CGFloat(nestLevel) * 4.0)
                
                contentView
                
            }
            .interactiveDismissDisabled()
            .navigationTitle(Text(PostStrings.CommentCompose.Title))
            .navigationBarTitleDisplayMode(.inline)
            .task(errorHandler: errorHandling, task: {
                try await store.load()
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading, content: {
                    Button(action: { dismissAction() }, label: { Text(CommonStrings.Cancel) })
                })
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                        executing(action: { try await store.submit() }, errorHandler: errorHandling)
                    }, label: {
                        Text(CommonStrings.Submit)
                    })
                })
            })
        }
    }
    
    private var contentView: some View {
        HStack(spacing: .zero) {
            VStack(alignment: .leading, spacing: Size.extraSmall.rawValue) {
                HStack(alignment: .lastTextBaseline, spacing: Size.extraSmall.rawValue) {
                    
                    userSelector
                    
                    Spacer()
                    Text(Date().localisedOffset)
                        .font(.captionStandard)
                }
                
                TabView(
                    selection: $selectedSegment.animation(.bouncy),
                    content: {
                        TextEditor(text: $store.commentText)
                            .background(content: { Colour.secondaryBackground.swiftUIColor })
                            .tag(Segment.parent)
                        
                        VStack(alignment: .leading) {
                            Markdown(store.commentText)
                            
                            Spacer()
                        }
                        .tag(Segment.preview)
                        .frame(width: .greatestFiniteMagnitude)
                    }
                ).tabViewStyle(.page(indexDisplayMode: .always))
                
                HStack(spacing: Size.small.rawValue) {
                    Spacer()
                    
                    Group {
                        Text("1")
                        
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    .font(.footnote)
                    .fontDesign(.monospaced)
                    .foregroundStyle(.orange)
                }
            }.padding(.smallMedium)
        }
    }
    
    private var userSelector: some View {
        Group {
            if selectedSegment == .parent && store.postAsUsers.isEmpty == false {
                Menu(content: {
                    ForEach(store.postAsUsers, id: \.id) { user in
                        Button(action: {
                            store.selectedUser = user
                        }, label: {
                            Label(title: {
                                Text(user.name ?? "")
                            }, icon: {
                                if store.selectedUser?.id == user.id {
                                    Image(systemName: "checkmark.circle")
                                }
                            })
                        })
                    }
                }, label: {
                    Text("\(store.selectedUser?.name ?? "") \(Image(systemName: "chevron.up.chevron.down"))")
                        .font(.subheadingBold)
                })
            } else {
                Text(store.selectedUser?.name ?? "")
                    .font(.subheadingBold)
            }
        }
    }
}
