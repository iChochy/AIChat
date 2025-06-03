import SwiftUI

// MARK: - View + Markdown Style

extension View {
    public func markdownStyle(_ style: MarkdownStyle) -> some View {
        modifier(MarkdownStyleModifier(style))
    }
}

// MARK: - Markdown Style

public struct MarkdownStyle {

    // MARK: - BlockPadding

    public struct BlockPadding {
        public let top: CGFloat
        public let bottom: CGFloat

        public init(top: CGFloat, bottom: CGFloat) {
            self.top = top
            self.bottom = bottom
        }
    }

    // MARK: - HeaderStyle

    public struct HeaderStyle {
        public let padding: BlockPadding
        public let font: Font
        public let color: Color

        public init(padding: BlockPadding, font: Font, color: Color) {
            self.font = font
            self.padding = padding
            self.color = color
        }
    }

    // MARK: - ParagraphStyle

    public struct ParagraphStyle {
        public let padding: BlockPadding
        public let font: Font
        public let color: Color

        public init(padding: BlockPadding, font: Font, color: Color) {
            self.padding = padding
            self.font = font
            self.color = color
        }
    }

    // MARK: - ImageStyle

    public struct ImageStyle {
        public let padding: BlockPadding
        public let cornerRadius: CGFloat
        public let bundle: Bundle?

        public init(padding: BlockPadding, cornerRadius: CGFloat, bundle: Bundle?) {
            self.padding = padding
            self.cornerRadius = cornerRadius
            self.bundle = bundle
        }
    }

    // MARK: - UnorderedListStyle

    public struct UnorderedListStyle {

        public struct Element {
            public let bullet: String
            public let bulletPadding: CGFloat
            public let bulletFont: Font
            public let indentation: CGFloat
            public let font: Font

            public init(
                bullet: String,
                bulletPadding: CGFloat,
                bulletFont: Font,
                indentation: CGFloat,
                font: Font
            ) {
                self.bullet = bullet
                self.bulletPadding = bulletPadding
                self.bulletFont = bulletFont
                self.indentation = indentation
                self.font = font
            }
        }

        public let padding: BlockPadding
        public let element: Element

        public init(
            padding: BlockPadding,
            element: Element
        ) {
            self.padding = padding
            self.element = element
        }
    }

    // MARK: - OrderedListStyle

    public struct OrderedListStyle {

        public struct Element {
            public let bulletPadding: CGFloat
            public let bulletFont: Font
            public let indentation: CGFloat
            public let font: Font

            public init(
                bulletPadding: CGFloat,
                bulletFont: Font,
                indentation: CGFloat,
                font: Font
            ) {
                self.bulletPadding = bulletPadding
                self.bulletFont = bulletFont
                self.indentation = indentation
                self.font = font
            }
        }

        public let padding: BlockPadding
        public let element: Element

        public init(
            padding: BlockPadding,
            element: Element
        ) {
            self.padding = padding
            self.element = element
        }
    }

    // MARK: - BlockquoteStyle

    public struct BlockquoteStyle {
        public struct LineDecoration {
            public let color: Color
            public let width: CGFloat
            public let padding: CGFloat

            public init(color: Color, width: CGFloat, padding: CGFloat) {
                self.color = color
                self.width = width
                self.padding = padding
            }
        }

        public let padding: BlockPadding
        public let indentation: CGFloat
        public let lineDecoration: LineDecoration?
        public let font: Font
        public let textColor: Color

        public init(
            padding: BlockPadding,
            indentation: CGFloat,
            lineDecoration: LineDecoration?,
            font: Font,
            textColor: Color
        ) {
            self.padding = padding
            self.indentation = indentation
            self.lineDecoration = lineDecoration
            self.font = font
            self.textColor = textColor
        }
    }

    // MARK: CodeStyle

    public struct CodeStyle {
        public let padding: BlockPadding
        public let internalPadding: EdgeInsets
        public let cornerRadius: CGFloat
        public let font: Font
        public let backgroundColor: Color

        public init(
            padding: BlockPadding,
            internalPadding: EdgeInsets,
            cornerRadius: CGFloat,
            font: Font,
            backgroundColor: Color
        ) {
            self.padding = padding
            self.internalPadding = internalPadding
            self.cornerRadius = cornerRadius
            self.font = font
            self.backgroundColor = backgroundColor
        }
    }

    // MARK: DividerStyle

    public struct DividerStyle {
        public let padding: BlockPadding
        public let color: Color
        public let width: CGFloat

        public init(padding: BlockPadding, color: Color, width: CGFloat) {
            self.padding = padding
            self.color = color
            self.width = width
        }
    }

    // MARK: - TableStyle

    public struct TableStyle {
        public let padding: BlockPadding
        public let headerFont: Font
        public let headerColor: Color
        public let cellFont: Font
        public let cellColor: Color

        public init(
            padding: BlockPadding,
            headerFont: Font,
            headerColor: Color,
            cellFont: Font,
            cellColor: Color
        ) {
            self.padding = padding
            self.headerFont = headerFont
            self.headerColor = headerColor
            self.cellFont = cellFont
            self.cellColor = cellColor
        }
    }

    // MARK: Properties

    public let header1: HeaderStyle
    public let header2: HeaderStyle
    public let header3: HeaderStyle
    public let header4: HeaderStyle
    public let header5: HeaderStyle
    public let header6: HeaderStyle

    public let paragraph: ParagraphStyle

    public let image: ImageStyle

    public let unorderedList: UnorderedListStyle
    public let orderedList: OrderedListStyle

    public let blockquote: BlockquoteStyle

    public let code: CodeStyle

    public let divider: DividerStyle

    public let table: TableStyle

    // MARK: Initializer

    public init(
        header1: HeaderStyle = .init(
            padding: .init(top: 16, bottom: 4),
            font: .system(.largeTitle).bold(),
            color: .primary
        ),
        header2: HeaderStyle = .init(
            padding: .init(top: 8, bottom: 0),
            font: .system(.title).bold(),
            color: .primary
        ),
        header3: HeaderStyle = .init(
            padding: .init(top: 8, bottom: 0),
            font: .system(.title2).bold(),
            color: .primary
        ),
        header4: HeaderStyle = .init(
            padding: .init(top: 8, bottom: 0),
            font: .system(.title3).bold(),
            color: .primary
        ),
        header5: HeaderStyle = .init(
            padding: .init(top: 8, bottom: 0),
            font: .system(.title3).bold(),
            color: .primary
        ),
        header6: HeaderStyle = .init(
            padding: .init(top: 8, bottom: 0),
            font: .system(.title3).bold(),
            color: .primary
        ),
        paragraph: ParagraphStyle = .init(
            padding: .init(top: 10, bottom: 10),
            font: .system(.body),
            color: .primary
        ),
        image: ImageStyle = .init(
            padding: .init(top: 10, bottom: 10),
            cornerRadius: 8,
            bundle: nil
        ),
        unorderedList: UnorderedListStyle = .init(
            padding: .init(top: 10, bottom: 10),
            element: .init(
                bullet: "•",
                bulletPadding: 4,
                bulletFont: .system(.body).bold(),
                indentation: 16,
                font: .system(.body)
            )
        ),
        orderedList: OrderedListStyle = .init(
            padding: .init(top: 10, bottom: 10),
            element: .init(
                bulletPadding: 4,
                bulletFont: .system(.body).bold(),
                indentation: 16,
                font: .system(.body)
            )
        ),
        blockquote: BlockquoteStyle = .init(
            padding: .init(top: 10, bottom: 12),
            indentation: 16,
            lineDecoration: .init(
                color: .secondary,
                width: 2,
                padding: 8
            ),
            font: .system(.body),
            textColor: .secondary
        ),
        code: CodeStyle = .init(
            padding: .init(top: 10, bottom: 10),
            internalPadding: .init(
                top: 16,
                leading: 16,
                bottom: 16,
                trailing: 16
            ),
            cornerRadius: 8,
            font: .system(.caption).monospaced(),
            backgroundColor: .secondary.opacity(0.2)
        ),
        divider: DividerStyle = .init(
            padding: .init(top: 10, bottom: 10),
            color: .secondary.opacity(0.3),
            width: 1
        ),
        table: TableStyle = .init(
            padding: .init(top: 10, bottom: 10),
            headerFont: .system(.headline).bold(),
            headerColor: .primary,
            cellFont: .system(.body),
            cellColor: .primary
        )
    ) {
        self.header1 = header1
        self.header2 = header2
        self.header3 = header3
        self.header4 = header4
        self.header5 = header5
        self.header6 = header6
        self.paragraph = paragraph
        self.image = image
        self.unorderedList = unorderedList
        self.orderedList = orderedList
        self.blockquote = blockquote
        self.code = code
        self.divider = divider
        self.table = table
    }
}

// MARK: - Environment Key / Value

struct MarkdownStyleKey: EnvironmentKey {
    static let defaultValue: MarkdownStyle = MarkdownStyle()
}

extension EnvironmentValues {
    var markdownStyle: MarkdownStyle {
        get { // swiftlint:disable:this implicit_getter
            return self[MarkdownStyleKey.self]
        }
        set {
            self[MarkdownStyleKey.self] = newValue
        }
    }
}

// MARK: - Markdown Style Modifier

private struct MarkdownStyleModifier: ViewModifier {

    let style: MarkdownStyle

    init(_ style: MarkdownStyle) {
        self.style = style
    }

    func body(content: Content) -> some View {
        content
            .environment(\.markdownStyle, style)
    }
}
