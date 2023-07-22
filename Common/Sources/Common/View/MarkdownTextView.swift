import Foundation
import SwiftUI

public struct MarkdownTextView: View {
    
    private let text: String
    
    public init(text: String) {
        self.text = text
    }
    
    public var body: some View {
        if let markdown = try? AttributedString(
            markdown: text,
            options: .init(
                allowsExtendedAttributes: true,
                interpretedSyntax: .inlineOnlyPreservingWhitespace,
                failurePolicy: .returnPartiallyParsedIfPossible
            )
        ) {
            Text(markdown)
                .font(.captionStandard)
        } else {
            Text(text)
                .font(.captionStandard)
        }
    }
}
