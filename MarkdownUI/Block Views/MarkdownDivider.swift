import SwiftUI

struct MarkdownDivider: View {

    @Environment(\.markdownStyle) private var style

    init(_ divider: MarkdownBlock.Divider) {
        //
    }

    var body: some View {
        let divider = style.divider
        divider.color
            .frame(height: divider.width)
            .frame(maxWidth: .infinity)
            .padding(.top, divider.padding.top)
            .padding(.bottom, divider.padding.bottom)
    }
}
