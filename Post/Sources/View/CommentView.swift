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
    
    struct CommentLine: Shape {
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.move(to: CGPoint(x: rect.midX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            }
        }
    }
    
    struct SecondaryCommentCurve: Shape {
        
        let drawsBottomLine: Bool
        
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.move(to: CGPoint(x: rect.minX, y: rect.minY + 5))
                
                path.addQuadCurve(
                    to: CGPoint(x: rect.maxX, y: 20),
                    control: CGPoint(x: rect.minX, y: 20)
                )
                path.move(to: CGPoint(x: rect.minX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + 5))
                
                if drawsBottomLine {
                    path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
                }
            }
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: .zero) {
            Spacer(minLength: 12)
 
            if nestLevel >= 1 {
                Spacer(minLength: 12)
            }
            
            if comment.parentId != nil {
//                Spacer(minLength: 12)
                ForEach(1..<(nestLevel)) { depth in
                    if (comment.linesToDraw & (1 << depth)) != 0 {
                        CommentLine()
                            .stroke(Color.gray, lineWidth: 1)
                            .frame(width: 1)
                        Spacer(minLength: 31) // Size of curve + half/avatar(24) - 1 (line)
                    } else {
                        Spacer(minLength: 32) // Size of curve + half/avatar(24)
                    }
//                    else {
////                        Text("0")
//                    }
                }
                
                SecondaryCommentCurve(drawsBottomLine: comment.hasNextSibling)
                    .stroke(Color.gray, lineWidth: 1)
                    .frame(width: 20)
            }
            
            VStack(spacing: .zero) {
                Circle()
                    .frame(width: 24, height: 24)
                    .padding(.top, 10)
                
                if comment.children?.isEmpty == false {
                    CommentLine()
                        .stroke(Color.gray, lineWidth: 1)
                        .frame(width: 1)
                }
            }
            
            VStack(alignment: .leading, spacing: Size.extraSmall.rawValue) {
                HStack(alignment: .lastTextBaseline, spacing: Size.extraSmall.rawValue) {
                    Text("\(nestLevel)")
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
