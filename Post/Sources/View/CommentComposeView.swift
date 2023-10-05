import Foundation
import Common
import SwiftUI

struct CommentComposeView: View {
    var siteUrl: URL
    var postId: Int
    var parentId: Int?
    
    @UseCase private var createUseCase: CreateCommentUseCase
    @State private var commentText: String = ""
    @State private var errorHandling = ErrorHandling()
    @State private var isSubmitting = false
    
    @Environment(\.dismiss) private var dismissAction
    
    init(siteUrl: URL, postId: Int, parentId: Int?) {
        self.siteUrl = siteUrl
        self.postId = postId
        self.parentId = parentId
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField(text: $commentText, label: { Text("Content") })
                    .presentationDetents([.medium, .large])
                    .backgroundStyle(.secondary)
                    .padding(.medium)
                
                Spacer()
            }
            .navigationTitle(Text("Replying to..."))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                        if isSubmitting == false {
                            executing(action: {
                                try await createUseCase.call(
                                    input: .init(
                                        siteUrl: siteUrl,
                                        content: commentText,
                                        postId: postId,
                                        parentId: parentId
                                    )
                                )
                            }, errorHandler: errorHandling, completion: {
                                dismissAction()
                            }, catching: { _ in
                                isSubmitting = false
                                return false
                            })
                        }
                    }, label: {
                        Text("Submit")
                    })
                })
            })
            .safeAreaInset(edge: .bottom, content: {
                HStack {
                    Button(action: {}, label: { Text("Bold") })
                }
            })
        }
    }
}
