import Foundation
import SwiftUI
import Common

struct PostView: View {
    
    @State var post: PostSummary
    var fullView: Bool
    
    @State private var errorHandling = ErrorHandling()
    @UseCase private var voteUseCase: PostVoteUseCase
    
    private var scoreColour: Color {
        switch post.myVote {
        case 1: return .orange
        case -1: return .blue
        default: return .gray
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Size.small.rawValue) {
            Text(post.communityName ?? "")
                .font(.subheadingSemiBold)
                .fontDesign(.rounded)
                .padding([.horizontal, .top], .medium)
            
            Text(post.title)
                .font(.titleStandard)
                .fontDesign(.serif)
                .padding(.horizontal, .medium)
            
            Group {
                if let _thumbnail = post.thumbnail {
                    PostPreviewImageView(imageUrl: _thumbnail)
                        .frame(height: 250)
                }
                
                if let _body = post.body, _body.isEmpty == false {
                    MarkdownTextView(text: _body)
                        .lineLimit(fullView ? nil : 3)
                        .padding(.horizontal, .medium)
                }
            }
            .padding(.bottom, .small)
            
            HStack {
                Text(post.creatorName ?? "")
                    .font(.subheadingBold)
                    .fontDesign(.rounded)
                
                Spacer()
                
                Text(post.score)
                    .font(.footnote)
                    .fontDesign(.monospaced)
                    .foregroundStyle(scoreColour)
            }
            .padding([.horizontal, .bottom], .medium)
            
            if fullView {
                HStack {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "arrow.up")
                            .tint(post.myVote > 0 ? .orange : .gray)
                    })
                    
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "arrow.down")
                            .tint(post.myVote < 0 ? .blue : .gray)
                    })
                }
                .padding([.horizontal, .bottom], .medium)
            }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true, content: {
            Button(action: {
                executing(action: { post = try await voteUseCase.call(input: .init(siteUrl: post.siteUrl, postId: post.id, voteType: .up)) }, errorHandler: errorHandling)
            }, label: {
                Image(systemName: post.myVote > 0 ? "arrow.uturn.up" : "arrow.up")
            })
            .tint(Color.orange)
        })
        .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
            Button(action: {
                executing(action: { post = try await voteUseCase.call(input: .init(siteUrl: post.siteUrl, postId: post.id, voteType: .down)) }, errorHandler: errorHandling)
            }, label: {
                Image(systemName: post.myVote < 1 ? "arrow.uturn.down" : "arrow.down")
            })
            .tint(Color.blue)
        })
    }
}

#Preview {
    PostView(
        post: PostSummary(
            id: 0,
            title: "Cats are sometimes very cute but sometimes very rude",
            thumbnail: URL(string: "http://placekitten.com/g/200/300"),
            body: "Sometimes they're ok",
            creatorId: 0,
            creatorName: "CatCreator",
            communityId: 0,
            communityName: "CatsCommunity",
            score: "0",
            siteUrl: URL(string: "")!
        ),
        fullView: true
    )
}
