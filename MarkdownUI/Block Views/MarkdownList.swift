import SwiftUI

struct MarkdownList: View {

    private let listType: MarkdownBlock.ListType

    private let level: Int

    private let items: [MarkdownBlock.ListItem]

    @Environment(\.markdownStyle) private var style

    init(_ list: MarkdownBlock.List) {
        listType = list.type
        level = list.indentationLevel
        items = list.items
    }

    var body: some View {
        let padding = switch listType {
        case .unordered: style.unorderedList.padding
        case .ordered: style.orderedList.padding
        }
        VStack {
            ForEach(items) { item in
                switch listType {
                case .unordered:
                    MarkdownUnorderedListElement(item.text, level: level, path: item.path)
                case .ordered:
                    MarkdownOrderedListElement(item.text, level: level, path: item.path)
                }
                if let sublist = item.sublist {
                    MarkdownList(sublist)
                }
            }
        }
        .padding(.top, level > 1 ? 0 : padding.top - 1)
        .padding(.bottom, level > 1 ? 0 : padding.bottom - 1)
    }
}
