import SwiftUI

struct MarkdownUnorderedListElement: View {

    private let content: AttributedString
    private let level: Int
    private let path: [Int]

    @Environment(\.markdownStyle) private var style

    init(
        _ content: AttributedString,
        level: Int,
        path: [Int]
    ) {
        self.content = content
        self.level = level
        self.path = path
    }

    var body: some View {
        let element = style.unorderedList.element
        HStack(alignment: .top, spacing: element.bulletPadding) {
            Text(element.bullet)
                .font(element.bulletFont)
            Text(content)
                .font(element.font)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.leading, CGFloat(level - 1) * element.indentation)
        .padding(.vertical, 2)
    }
}
