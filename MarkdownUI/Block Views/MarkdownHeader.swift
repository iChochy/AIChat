import SwiftUI

struct MarkdownHeader: View {

    private let text: AttributedString

    private let level: Int

    @Environment(\.markdownStyle) private var style

    init(_ header: MarkdownBlock.Header) {
        self.text = header.text
        self.level = header.level
    }

    var body: some View {
        let header = styleForHeader(level: level)
        Text(text)
            .font(header.font)
            .foregroundStyle(header.color)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, header.padding.top)
            .padding(.bottom, header.padding.bottom)
    }

    private func styleForHeader(level: Int) -> MarkdownStyle.HeaderStyle {
        switch level {
        case 1: style.header1
        case 2: style.header2
        case 3: style.header3
        case 4: style.header4
        case 5: style.header5
        case 6: style.header6
        default: style.header6
        }
    }
}
