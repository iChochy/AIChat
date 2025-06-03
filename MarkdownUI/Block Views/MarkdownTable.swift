import SwiftUI

struct MarkdownTable: View {

    private let rows: [MarkdownBlock.Table.Row]
    private let columns: [MarkdownBlock.Table.Column]

    @Environment(\.markdownStyle) private var style

    init(_ table: MarkdownBlock.Table) {
        rows = table.rows
        columns = table.columns
    }

    var body: some View {
        if #available(iOS 16.0, macOS 13.0, *) {
            Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 12) {
                Divider()
                ForEach(rows) { row in
                    GridRow {
                        ForEach(row.cells) { cell in
                            if row.isHeader {
                                Text(cell.text)
                                    .font(style.table.headerFont)
                                    .foregroundStyle(style.table.headerColor)
                                    .gridColumnAlignment(columns[cell.index].alignment)
                            } else {
                                Text(cell.text)
                                    .font(style.table.cellFont)
                                    .foregroundStyle(style.table.cellColor)
                            }
                        }
                    }
                    Divider()
                }
            }
            .padding(.top, style.table.padding.top)
            .padding(.bottom, style.table.padding.bottom)
        } else {
            VStack {
                Divider()
                ForEach(rows) { row in
                    HStack {
                        ForEach(row.cells) { cell in
                            if row.isHeader {
                                Text(cell.text)
                                    .font(.headline).bold()
                                    .foregroundStyle(.primary)
                                    .frame(maxWidth: .infinity)
                            } else {
                                Text(cell.text)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    Divider()
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, style.table.padding.top)
            .padding(.bottom, style.table.padding.bottom)
        }
    }
}
