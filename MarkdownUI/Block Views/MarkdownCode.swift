import SwiftUI

struct MarkdownCode: View {

    private let text: AttributedString

    // We don't actually care about this,
    // but maybe we will add syntax highlighting later.
    private let languageHint: String?

    @Environment(\.markdownStyle) private var style

    init(_ code: MarkdownBlock.Code) {
        self.text = code.text
        self.languageHint = code.languageHint
    }

    var body: some View {
        let code = style.code
        Text(text)
            .font(code.font)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(code.internalPadding)
            .background(code.backgroundColor)
            .cornerRadius(code.cornerRadius)
            .padding(.top, code.padding.top)
            .padding(.bottom, code.padding.bottom)
    }
}
