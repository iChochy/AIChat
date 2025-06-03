import SwiftUI

// MARK: - Markdown Document

/// Represents a Markdown document, as a list of ``MarkdownBlock`` objects.
public struct MarkdownDocument {

    /// The parsed blocks representing the Markdown document.
    public let blocks: [MarkdownBlock]

    /// Parses a Markdown formatted string and divides it into `MarkdownBlock` objects.
    /// Each block has an id, a type, an indentation level, and the text content of the block as
    /// an `AttributedString`.
    ///
    /// - Parameters:
    ///   - markdown:
    ///         The string that contains the Markdown formatting.
    ///   - baseURL:
    ///         The base URL to use when resolving Markdown URLs. The initializer treats URLs as
    ///         being relative to this URL. If this value is nil, the initializer doesn’t resolve URLs.
    ///         The default is `nil`.
    ///   - languageCode:
    ///         The BCP-47 language code for this document. Default is `"en"` for English.
    ///
    public init(_ markdown: String, baseURL: URL? = nil, languageCode: String = "en") throws {

        let markdownOptions = AttributedString.MarkdownParsingOptions(
            allowsExtendedAttributes: true,
            interpretedSyntax: .full,
            failurePolicy: .returnPartiallyParsedIfPossible,
            languageCode: languageCode
        )

        let string = try AttributedString(
            markdown: markdown,
            options: markdownOptions,
            baseURL: baseURL
        )

        let runs = string.runs[\.presentationIntent]

        var blocksByID: [MarkdownBlock.ID: MarkdownBlock] = [:]

        var blockOrder: [MarkdownBlock.ID] = []

        var listsByID: [MarkdownBlock.ID: MarkdownBlock.List] = [:]

        // This is kludgy, but we will give custom views a high ID
        var currentCustomViewID: Int = 1_000_000_000

    runLoop: for (run, range) in runs {

        guard let run, !run.components.isEmpty else {
            // This part doesn't have any Markdown intent.
            // Let's see if there's an HTML block in there.
            // If so, we will try to interpret it as a custom block.
            let part = string[range]
            if part.inlinePresentationIntent == .blockHTML {
                let string = String(part.characters)
                if let tag = Self.extractCustomViewTag(from: string) {
                    let id = currentCustomViewID
                    currentCustomViewID += 1
                    blockOrder.append(id)
                    blocksByID[id] = .customView(.init(id: id, tag: tag))
                }
            }

            continue runLoop
        }

        let components: [PresentationIntent.IntentType] = Array(run.components.reversed())

        let id = components[0].identity
        let level = run.indentationLevel

        let firstComponent = components[0]
        switch firstComponent.kind {

        case .header(let headerLevel):
            blockOrder.append(id)
            let text = AttributedString(string[range])
            blocksByID[id] = .header(.init(id: id, indentationLevel: level, level: headerLevel, text: text))

        case .paragraph:
            blockOrder.append(id)
            let text = AttributedString(string[range])
            if let url = string[range].imageURL {
                blocksByID[id] = .image(.init(id: id, indentationLevel: level, text: text, url: url))
            } else {
                blocksByID[id] = .paragraph(.init(id: id, indentationLevel: level, text: text))
            }

        case .thematicBreak:
            blockOrder.append(id)
            blocksByID[id] = .divider(.init(id: id, indentationLevel: level))

        case .blockQuote:
            blockOrder.append(id)
            let text = AttributedString(string[range])
            blocksByID[id] = .blockquote(.init(id: id, indentationLevel: level, text: text))

        case .codeBlock(let hint):
            blockOrder.append(id)
            // Strip the superfluous newline from the end of code blocks.
            let text = AttributedString(string[range].characters.dropLast(1))
            blocksByID[id] = .code(.init(id: id, indentationLevel: level, languageHint: hint, text: text))

        case .unorderedList, .orderedList:

            let text = AttributedString(string[range])

            var components = components.dropLast(1)

            var path: [
                (
                    listID: MarkdownBlock.ID,
                    itemIndex: Int,
                    itemID: MarkdownBlock.ID,
                    listType: MarkdownBlock.ListType
                )
            ] = []

        componentLoop: while !components.isEmpty {
            guard let listComponent = components.first else {
                break componentLoop
            }
            components.removeFirst()
            let listType: MarkdownBlock.ListType
            switch listComponent.kind {
            case .unorderedList: listType = .unordered
            case .orderedList: listType = .ordered
            default:
                break componentLoop
            }

            let listID: MarkdownBlock.ID = listComponent.identity

            guard let itemComponent = components.first else {
                break componentLoop
            }
            components.removeFirst()
            guard case .listItem(let itemIndex) = itemComponent.kind else {
                break componentLoop
            }

            path.append(
                (
                    listID: listID,
                    itemIndex: itemIndex,
                    itemID: itemComponent.identity,
                    listType: listType
                )
            )
        }

            guard !path.isEmpty else {
                continue runLoop
            }

            var parentListStack: [
                (
                    listID: MarkdownBlock.ID,
                    itemIndex: Int,
                    itemID: MarkdownBlock.ID,
                    listType: MarkdownBlock.ListType
                )
            ] = []

            for listLevel in path {
                if let existingList = listsByID[listLevel.listID] {
                    if listLevel.itemIndex <= existingList.items.count {
                        // List item already exists
                    } else {
                        // List item does not already exist
                        let item = MarkdownBlock.ListItem(id: listLevel.itemID, path: path.map { $0.itemIndex }, text: text, sublist: nil)
                        let updatedList = existingList.insertingItem(item, at: listLevel.itemIndex)
                        listsByID[listLevel.listID] = updatedList

                        var listToUpdate: MarkdownBlock.List = updatedList
                        for parentListLevel in parentListStack {
                            guard let parentList = listsByID[parentListLevel.listID] else {
                                continue
                            }
                            let updatedItem = parentList.items[parentListLevel.itemIndex - 1].withSublist(listToUpdate)
                            let updatedParentList = parentList.replacingItem(at: parentListLevel.itemIndex, with: updatedItem)
                            listsByID[parentListLevel.listID] = updatedParentList
                            listToUpdate = updatedParentList
                        }
                    }
                } else {
                    // We are going to assume that the only reason
                    // a list level doesn't exist is that it's the
                    // current list item's list that needs to be added.
                    let newList = MarkdownBlock.List(
                        id: listLevel.listID,
                        indentationLevel: level,
                        type: listLevel.listType,
                        items: [
                            .init(id: listLevel.itemID, path: path.map { $0.itemIndex }, text: text, sublist: nil)
                        ]
                    )
                    listsByID[listLevel.listID] = newList

                    var listToUpdate: MarkdownBlock.List = newList
                    for parentListLevel in parentListStack {
                        guard let parentList = listsByID[parentListLevel.listID] else {
                            continue
                        }
                        let updatedItem = parentList.items[parentListLevel.itemIndex - 1].withSublist(listToUpdate)
                        let updatedParentList = parentList.replacingItem(at: parentListLevel.itemIndex, with: updatedItem)
                        listsByID[parentListLevel.listID] = updatedParentList
                        listToUpdate = updatedParentList
                    }

                    break
                }

                parentListStack.insert(listLevel, at: 0)
            }

            if let list = listsByID[id] {
                if blocksByID[id] == nil {
                    blockOrder.append(id)
                }
                blocksByID[id] = .list(list)
            } else {
                // Should not happen
            }

        case .table(let columns):
            let isHeaderRow: Bool
            let rowID: MarkdownBlock.ID
            let rowIndex: Int
            let cell: MarkdownBlock.Table.Row.Cell

            if let (id, index) = components.firstTableHeaderRow {
                isHeaderRow = true
                rowID = id
                rowIndex = index
            } else if let (id, index) = components.firstTableRow {
                isHeaderRow = false
                rowID = id
                rowIndex = index
            } else {
                // Should not happen.
                break
            }

            if let (id, index) = components.firstTableCell {
                let text = AttributedString(string[range])
                cell = MarkdownBlock.Table.Row.Cell(id: id, index: index, text: text)
            } else {
                // Should not happen.
                break
            }

            if let block = blocksByID[id], case .table(let table) = block {
                if table.rows.count > rowIndex {
                    // Row already exists
                    let row = table.rows[rowIndex]
                    let newRow = row.insertingCell(cell, at: cell.index)
                    let newTable = table.replacingRow(at: rowIndex, with: newRow)
                    blocksByID[id] = .table(newTable)
                } else {
                    let row = MarkdownBlock.Table.Row(id: rowID, index: rowIndex, isHeader: isHeaderRow, cells: [cell])
                    let newTable = table.insertingRow(row, at: rowIndex)
                    blocksByID[id] = .table(newTable)
                }
            } else {
                blockOrder.append(id)
                let row = MarkdownBlock.Table.Row(id: rowID, index: rowIndex, isHeader: isHeaderRow, cells: [cell])
                let columns: [MarkdownBlock.Table.Column] = columns.map {
                    let alignment: HorizontalAlignment = switch $0.alignment {
                    case .left: .leading
                    case .center: .center
                    case .right: .trailing
                    @unknown default: .leading
                    }
                    return .init(alignment: alignment)
                }
                blocksByID[id] = .table(.init(id: id, indentationLevel: level, rows: [row], columns: columns))
            }

        default:
            continue runLoop
        }
    }

        self.blocks = blockOrder.compactMap { blocksByID[$0] }
    }


    private static func extractCustomViewTag(from string: String) -> String? {
        let scanner = Scanner(string: string)
        scanner.charactersToBeSkipped = .none

        _ = scanner.scanUpToString(#"<view tag=""#)
        guard scanner.scanString(#"<view tag=""#) != nil else {
            return nil
        }
        guard let tag = scanner.scanUpToString(#"""#) else {
            return nil
        }
        guard scanner.scanString(#"""#) != nil else {
            return nil
        }
        _ = scanner.scanCharacters(from: .whitespaces)
        guard scanner.scanString("/>") != nil else {
            return nil
        }
        return tag
    }

}

// MARK: - Helpers

fileprivate extension [PresentationIntent.IntentType] {
    var firstTableHeaderRow: (id: MarkdownBlock.ID, index: Int)? {
        for intent in self {
            if case .tableHeaderRow = intent.kind {
                return (id: intent.identity, index: 0)
            }
        }
        return nil
    }

    var firstTableRow: (id: MarkdownBlock.ID, index: Int)? {
        for intent in self {
            if case .tableRow(let index) = intent.kind {
                return (id: intent.identity, index: index)
            }
        }
        return nil
    }

    var firstTableCell: (id: MarkdownBlock.ID, index: Int)? {
        for intent in self {
            if case .tableCell(let index) = intent.kind {
                return (id: intent.identity, index: index)
            }
        }
        return nil
    }
}
