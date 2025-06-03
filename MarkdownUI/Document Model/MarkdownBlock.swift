import SwiftUI

// MARK: - MarkdownBlockType

public protocol MarkdownBlockType: Identifiable {
    var id: MarkdownBlock.ID { get }
    var indentationLevel: Int { get }
}

// MARK: - MarkdownBlock

/// Represents a Markdown block element.
public enum MarkdownBlock: Identifiable {

    case header(Header)
    case paragraph(Paragraph)
    case divider(Divider)
    case blockquote(Blockquote)
    case code(Code)
    case list(List)
    case table(Table)
    case image(Image)
    case customView(CustomView)

    public typealias ID = Int

    // MARK: - Header

    public struct Header: MarkdownBlockType {
        public let id: MarkdownBlock.ID
        public let indentationLevel: Int
        public let level: Int
        public let text: AttributedString

        public init(id: MarkdownBlock.ID, indentationLevel: Int, level: Int, text: AttributedString) {
            self.id = id
            self.indentationLevel = indentationLevel
            self.level = level
            self.text = text
        }
    }

    // MARK: - Paragraph

    public struct Paragraph: MarkdownBlockType {
        public let id: MarkdownBlock.ID
        public let indentationLevel: Int
        public let text: AttributedString

        public init(id: MarkdownBlock.ID, indentationLevel: Int, text: AttributedString) {
            self.id = id
            self.indentationLevel = indentationLevel
            self.text = text
        }
    }

    // MARK: - Divider

    public struct Divider: MarkdownBlockType {
        public let id: MarkdownBlock.ID
        public let indentationLevel: Int

        public init(id: MarkdownBlock.ID, indentationLevel: Int) {
            self.id = id
            self.indentationLevel = indentationLevel
        }
    }

    // MARK: - Blockquote

    public struct Blockquote: MarkdownBlockType {
        public let id: MarkdownBlock.ID
        public let indentationLevel: Int
        public let text: AttributedString

        public init(id: MarkdownBlock.ID, indentationLevel: Int, text: AttributedString) {
            self.id = id
            self.indentationLevel = indentationLevel
            self.text = text
        }
    }

    // MARK: - Code

    public struct Code: MarkdownBlockType {
        public let id: MarkdownBlock.ID
        public let indentationLevel: Int
        public let languageHint: String?
        public let text: AttributedString

        public init(id: MarkdownBlock.ID, indentationLevel: Int, languageHint: String? = nil, text: AttributedString) {
            self.id = id
            self.indentationLevel = indentationLevel
            self.languageHint = languageHint
            self.text = text
        }
    }

    // MARK: - List

    public struct List: MarkdownBlockType {
        public let id: MarkdownBlock.ID
        public let indentationLevel: Int
        public let type: ListType
        public let items: [ListItem]

        public init(id: MarkdownBlock.ID, indentationLevel: Int, type: MarkdownBlock.ListType, items: [MarkdownBlock.ListItem]) {
            self.id = id
            self.indentationLevel = indentationLevel
            self.type = type
            self.items = items
        }

        internal func insertingItem(_ item: ListItem, at index: Int) -> List {
            var items = self.items
            items.insert(item, at: index - 1)
            return List(id: id, indentationLevel: indentationLevel, type: type, items: items)
        }

        internal func replacingItem(at index: Int, with item: ListItem) -> List {
            var items = self.items
            items[index - 1] = item
            return List(id: id, indentationLevel: indentationLevel, type: type, items: items)
        }
    }

    // MARK: ListType

    public enum ListType {
        case unordered
        case ordered
    }

    // MARK: ListItem

    public struct ListItem: Identifiable {
        public let id: MarkdownBlock.ID
        public let path: [Int]
        public let text: AttributedString
        public let sublist: List?

        public init(id: MarkdownBlock.ID, path: [Int], text: AttributedString, sublist: MarkdownBlock.List?) {
            self.id = id
            self.path = path
            self.text = text
            self.sublist = sublist
        }

        internal func withSublist(_ list: List) -> ListItem {
            return ListItem(id: id, path: path, text: text, sublist: list)
        }
    }

    // MARK: - Table

    public struct Table: MarkdownBlockType {

        public struct Row: Identifiable {

            public struct Cell: Identifiable {
                public let id: MarkdownBlock.ID
                public let index: Int
                public let text: AttributedString

                public init(id: MarkdownBlock.ID, index: Int, text: AttributedString) {
                    self.id = id
                    self.index = index
                    self.text = text
                }
            }

            public let id: MarkdownBlock.ID
            public let index: Int
            public let isHeader: Bool
            public let cells: [Cell]

            public init(id: MarkdownBlock.ID, index: Int, isHeader: Bool, cells: [Cell]) {
                self.id = id
                self.index = index
                self.isHeader = isHeader
                self.cells = cells
            }

            internal func insertingCell(_ cell: Cell, at index: Int) -> Row {
                var cells = self.cells
                cells.insert(cell, at: index)
                return Row(id: id, index: index, isHeader: isHeader, cells: cells)
            }
        }

        public struct Column {
            public let alignment: HorizontalAlignment

            public init(alignment: HorizontalAlignment) {
                self.alignment = alignment
            }
        }

        public let id: MarkdownBlock.ID
        public let indentationLevel: Int
        public let rows: [Row]
        public let columns: [Column]

        public init(id: MarkdownBlock.ID, indentationLevel: Int, rows: [Row], columns: [Column]) {
            self.id = id
            self.indentationLevel = indentationLevel
            self.rows = rows
            self.columns = columns
        }

        internal func insertingRow(_ row: Row, at index: Int) -> Table {
            var rows = self.rows
            rows.insert(row, at: index)
            return Table(id: id, indentationLevel: indentationLevel, rows: rows, columns: columns)
        }

        internal func replacingRow(at index: Int, with row: Row) -> Table {
            var rows = self.rows
            rows[index] = row
            return Table(id: id, indentationLevel: indentationLevel, rows: rows, columns: columns)
        }
    }

    // MARK: - Image

    public struct Image: MarkdownBlockType {
        public let id: MarkdownBlock.ID
        public let indentationLevel: Int
        public let text: AttributedString
        public let url: URL

        public init(id: MarkdownBlock.ID, indentationLevel: Int, text: AttributedString, url: URL) {
            self.id = id
            self.indentationLevel = indentationLevel
            self.text = text
            self.url = url
        }
    }

    // MARK: - CustomView

    public struct CustomView: MarkdownBlockType {
        public let id: MarkdownBlock.ID
        public let indentationLevel: Int = 0
        public let tag: String

        public init(id: MarkdownBlock.ID, tag: String) {
            self.id = id
            self.tag = tag
        }
    }

    // MARK: - id

    public var id: ID {
        switch self {
        case .header(let type): type.id
        case .paragraph(let type): type.id
        case .divider(let type): type.id
        case .blockquote(let type): type.id
        case .code(let type): type.id
        case .list(let type): type.id
        case .table(let type): type.id
        case .image(let type): type.id
        case .customView(let type): type.id
        }
    }

    // MARK: indentationLevel

    public var indentationLevel: Int {
        switch self {
        case .header(let type): type.indentationLevel
        case .paragraph(let type): type.indentationLevel
        case .divider(let type): type.indentationLevel
        case .blockquote(let type): type.indentationLevel
        case .code(let type): type.indentationLevel
        case .list(let type): type.indentationLevel
        case .table(let type): type.indentationLevel
        case .image(let type): type.indentationLevel
        case .customView(let type): type.indentationLevel
        }
    }
}
