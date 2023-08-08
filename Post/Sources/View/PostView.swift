import Foundation
import SwiftUI
import Common

struct PostView: View {
    
    var post: PostSummary
    var fullView: Bool
    
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
            }
            .padding([.horizontal, .bottom], .medium)
        }
        .background(Colour.secondaryBackground.swiftUIColor)
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
