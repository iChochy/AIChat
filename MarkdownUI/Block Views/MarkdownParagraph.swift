import SwiftUI

struct MarkdownParagraph: View {

    private let text: AttributedString

    @Environment(\.markdownStyle) private var style

    init(_ paragraph: MarkdownBlock.Paragraph) {
        self.text = paragraph.text
    }

    var body: some View {
        let paragraph = style.paragraph
        Text(text)
            .font(paragraph.font)
            .foregroundStyle(paragraph.color)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, paragraph.padding.top)
            .padding(.bottom, paragraph.padding.bottom)
    }
}
