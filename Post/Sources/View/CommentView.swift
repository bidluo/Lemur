import Foundation
import SwiftUI
import Common
import MarkdownUI

struct CommentView: View {
    
    @State var comment: CommentContent
    let siteUrl: URL
    let nestLevel: Int
    var scrollsContent: Bool = false
    
    var replyTapped: ((CommentContent) -> Void)?
    
    @State private var errorHandling = ErrorHandling()
    @UseCase private var voteUseCase: CommentVoteUseCase
    
    @Environment(\.authenticated) var authenticated
    
    private var myScore: Int { return comment.myScore ?? 0 }
    
    private var scoreColour: Color {
        switch comment.myScore {
        case 1: return .orange
        case -1: return .blue
        default: return .gray
        }
    }
    
    var body: some View {
        HStack(spacing: .zero) {
            if nestLevel > 0 {
                ForEach(0..<nestLevel, id: \.self) { level in
                    CommentColourPalette.standard.color(forNestLevel: level)
                        .frame(width: 4.0)
                }
            }
            
            VStack(alignment: .leading, spacing: Size.extraSmall.rawValue) {
                HStack(alignment: .lastTextBaseline, spacing: Size.extraSmall.rawValue) {
                    Text(comment.creatorName)
                        .font(.subheadingBold)
                    if comment.creatorIsLocal == false, let creatorHome = comment.creatorHome {
                        Text("@\(creatorHome)")
                            .font(.captionStandard)
                    }
                    
                    Spacer()
                    
                    if let publishDate = comment.publishDate {
                        Text(publishDate.localisedOffset)
                        .font(.captionStandard)
                    }
                }
                
                if scrollsContent {
                    ScrollView {
                        Markdown(comment.content)
                    }
                } else {
                    Markdown(comment.content)
                }
                
                HStack(spacing: Size.small.rawValue) {
                    Spacer()
                    
                    if let score = comment.score {
                        Group {
                            Text("\(score)")
                            
                            Image(systemName: "arrow.up.arrow.down")
                        }
                        .font(.footnote)
                        .fontDesign(.monospaced)
                        .foregroundStyle(scoreColour)
                    }
                }
                
            }.padding(.smallMedium)
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true, content: {
            if authenticated {
                Button(action: {
                    vote(type: .up)
                }, label: {
                    Image(systemName: myScore > 0 ? "arrow.uturn.up" : "arrow.up")
                })
                .tint(Color.orange)
            }
        })
        .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
            if authenticated {
                Button(action: {
                    replyTapped?(comment)
                }, label: {
                    Image(systemName: "arrowshape.turn.up.left.fill")
                })
                .tint(Color.green)
                
                Button(action: {
                    vote(type: .down)
                }, label: {
                    Image(systemName: myScore < 0 ? "arrow.uturn.down" : "arrow.down")
                })
                .tint(Color.blue)
            }
        })

    }
    
    private func vote(type: VoteType) {
        executing(
            action: {
                let result = try await voteUseCase.call(input: .init(siteUrl: siteUrl, commentId: comment.id, voteType: type))
                self.comment.score = result.score
                self.comment.myScore = result.myVote
            },
            errorHandler: errorHandling
        )
    }
}

extension CommentView {
    func replyTapped(_ handler: @escaping (CommentContent) -> Void) -> CommentView {
        var new = self
        new.replyTapped = handler
        return new
    }
}

struct CommentColourPalette {
    private let colours: [Color]
    
    // TODO: Update with real colours
    static var standard: CommentColourPalette {
        return CommentColourPalette(colours: [
            Color(red: 0.90, green: 0.49, blue: 0.13), // vibrant orange
            Color(red: 0.21, green: 0.61, blue: 0.35), // vibrant green
            Color(red: 0.61, green: 0.35, blue: 0.71), // vibrant purple
            Color(red: 0.30, green: 0.50, blue: 0.63), // vibrant blue
            Color(red: 0.75, green: 0.22, blue: 0.17), // vibrant red
            Color(red: 0.60, green: 0.31, blue: 0.64), // vibrant violet
            Color(red: 0.95, green: 0.61, blue: 0.07), // vibrant yellow
            Color(red: 0.11, green: 0.56, blue: 0.57), // vibrant teal
            Color(red: 0.85, green: 0.37, blue: 0.01), // vibrant tangerine
            Color(red: 0.46, green: 0.67, blue: 0.59)  // vibrant sea green
        ])
    }
    
    static var pastel: CommentColourPalette {
        return CommentColourPalette(colours: [
            Color(red: 1.00, green: 0.71, blue: 0.76), // pastel pink
            Color(red: 0.69, green: 0.88, blue: 0.90), // pastel blue
            Color(red: 1.00, green: 0.99, blue: 0.71), // pastel yellow
            Color(red: 0.68, green: 0.83, blue: 0.90), // pastel sky blue
            Color(red: 0.88, green: 0.65, blue: 0.88), // pastel purple
            Color(red: 0.69, green: 0.94, blue: 0.73), // pastel green
            Color(red: 0.96, green: 0.75, blue: 0.65), // pastel orange
            Color(red: 0.60, green: 0.75, blue: 0.90), // pastel indigo
            Color(red: 0.95, green: 0.68, blue: 0.73), // pastel red
            Color(red: 0.81, green: 0.81, blue: 0.80)
        ])
    }
    
    init(colours: [Color]) {
        self.colours = colours
    }
    
    func color(forNestLevel level: Int) -> Color {
        return colours[level % colours.count]
    }
}
