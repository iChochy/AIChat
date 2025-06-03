import SwiftUI

struct MarkdownBlockquote: View {

    private let text: AttributedString
    private let level: Int

    @Environment(\.markdownStyle) private var style

    init(_ blockquote: MarkdownBlock.Blockquote) {
        self.text = blockquote.text
        self.level = blockquote.indentationLevel
    }

    var body: some View {
        let blockquote = style.blockquote
        HStack(spacing: 0) {
            if let line = blockquote.lineDecoration {
                line.color
                    .frame(width: line.width)
                    .padding(.trailing, line.padding)
            }
            Text(text)
                .font(blockquote.font)
                .foregroundStyle(blockquote.textColor)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer(minLength: 0)
        }
        .padding(.leading, CGFloat(level - 1) * blockquote.indentation)
        .padding(.top, blockquote.padding.top)
        .padding(.bottom, blockquote.padding.bottom)

    }
}
