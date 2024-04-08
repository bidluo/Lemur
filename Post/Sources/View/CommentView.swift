import Foundation
import SwiftUI
import Common
import MarkdownUI

struct CommentView: View {
    
    @State var comment: CommentContent
    let siteUrl: URL
    let nestLevel: Int
    let expanded: Bool
    var scrollsContent: Bool = false
    
    var replyTapped: ((CommentContent) -> Void)?
    
    @State private var errorHandling = ErrorHandling()
    @UseCase private var voteUseCase: CommentVoteUseCase
    
    @Environment(\.authenticated) var authenticated
    
    private let baseSpacerLength: CGFloat = 10
    private let lineStrokeWidth: CGFloat = 1
    private let curveFrameWidth: CGFloat = 12
    private let avatarWidth: CGFloat = 16
    
    private var additionalSpacerForLine: CGFloat {
        (curveFrameWidth + avatarWidth / 2) - lineStrokeWidth
    }
    private var additionalSpacerNoLine: CGFloat {
        curveFrameWidth + avatarWidth / 2
    }
    
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
    
    struct CommentCurve: Shape {
        
        let drawsBottomLine: Bool
        
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.move(to: CGPoint(x: rect.minX, y: rect.minY + 5))
                
                path.addQuadCurve(
                    to: CGPoint(x: rect.maxX, y: 20),
                    control: CGPoint(x: rect.minX, y: 15)
                )
                path.move(to: CGPoint(x: rect.minX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + 5))
                
                if drawsBottomLine {
                    path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
                }
            }
        }
    }
    
    private var fadingGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.gray, Color.gray.opacity(0)]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: .zero) {
            Spacer(minLength: baseSpacerLength)
            
            if nestLevel >= 1 {
                Spacer(minLength: avatarWidth / 2)
            }
            
            if comment.parentId != nil {
                ForEach(Array(1..<nestLevel), id: \.self) { depth in
                    if (comment.linesToDraw & (1 << depth)) != 0 {
                        CommentLine()
                            .stroke(Color.gray, lineWidth: lineStrokeWidth)
                            .frame(width: lineStrokeWidth)
                        Spacer(minLength: additionalSpacerForLine)
                    } else {
                        Spacer(minLength: additionalSpacerNoLine)
                    }
                }
                
                CommentCurve(drawsBottomLine: comment.hasNextSibling)
                    .stroke(Color.gray, lineWidth: lineStrokeWidth)
                    .frame(width: curveFrameWidth)
            }
            
            VStack(spacing: .zero) {
                Circle()
                    .frame(width: avatarWidth, height: avatarWidth)
                    .padding(.top, 10)
                
                if comment.children?.isEmpty == false {
                    if expanded {
                        CommentLine()
                            .stroke(Color.gray, lineWidth: lineStrokeWidth)
                            .frame(width: lineStrokeWidth)
                    } else {
                        CommentLine()
                            .stroke(fadingGradient, style: StrokeStyle(lineWidth: lineStrokeWidth, lineCap: .round, dash: [5, 3]))
                            .frame(width: lineStrokeWidth)
                    }
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
                
                if expanded {
                    if scrollsContent {
                        ScrollView {
                            Markdown(comment.content)
                        }
                    } else {
                        Markdown(comment.content)
                    }
                }
                
                HStack(spacing: Size.small.rawValue) {
                    if let children = comment.children?.count, children > 0 {
                        Text(children == 1 ? PostStrings.Comment.Reply : PostStrings.Comment.Replies(children))
                            .foregroundStyle(.gray)
                    }
                    
                    if let score = comment.score {
                        Group {
                            Text("\(score)")
                            Image(systemName: "arrow.up.arrow.down")
                        }
                        .foregroundStyle(scoreColour)
                    }
                }
                .padding(.top, .extraSmall)
                .font(.footnote)
                .fontDesign(.monospaced)
                
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
