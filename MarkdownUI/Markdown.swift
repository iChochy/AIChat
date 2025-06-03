import SwiftUI

/// SwiftUI view that displays Markdown text as a lazy vertical stack of Markdown blocks.
public struct Markdown<Content: View>: View {

    public typealias CustomViewTag = String

    private let model: MarkdownDocument

    private let lazy: Bool

    private let customViewBuilder: (CustomViewTag) -> Content

    @Environment(\.markdownStyle) private var style

    /// Note: Do not recreate the ``MarkdownDocument`` for every SwiftUI refresh unless necessary.
    public init(_ model: MarkdownDocument, lazy: Bool, @ViewBuilder _ customViewBuilder: @escaping (CustomViewTag) -> Content) {
        self.model = model
        self.lazy = lazy
        self.customViewBuilder = customViewBuilder
    }

    public var body: some View {
        if lazy {
            LazyVStack(alignment: .leading, spacing: 0) {
                blocks
            }
        } else {
            VStack(alignment: .leading, spacing: 0) {
                blocks
            }
        }
    }

    @ViewBuilder private var blocks: some View {
        ForEach(model.blocks) { block in
            switch block {
            case .header(let header):
                MarkdownHeader(header)
            case .paragraph(let paragraph):
                MarkdownParagraph(paragraph)
            case .divider(let divider):
                MarkdownDivider(divider)
            case .blockquote(let blockquote):
                MarkdownBlockquote(blockquote)
            case .code(let code):
                MarkdownCode(code)
            case .list(let list):
                MarkdownList(list)
            case .table(let table):
                MarkdownTable(table)
            case .image(let image):
                MarkdownImage(image)
            case .customView(let customView):
                customViewBuilder(customView.tag)
            }
        }
    }
}

extension Markdown where Content == EmptyView {
    public init(_ model: MarkdownDocument, lazy: Bool) {
        self.model = model
        self.lazy = lazy
        self.customViewBuilder = { _ in EmptyView() }
    }
}

// MARK: - Preview

#if DEBUG
private let previewMarkdownDoc = try! MarkdownDocument(previewMarkdown)

#Preview("Markdown") {
    ScrollView {
        Markdown(previewMarkdownDoc, lazy: false) { tag in
            if tag == "myCustomView" {
                MyCustomView()
            }
        }
        .markdownStyle(MarkdownStyle())
        .tint(.blue) // Link color
        .padding()
    }
}

#Preview("Lazy Markdown") {
    ScrollView {
        Markdown(previewMarkdownDoc, lazy: true) { tag in
            if tag == "myCustomView" {
                MyCustomView()
            }
        }
        .markdownStyle(MarkdownStyle())
        .tint(.blue) // Link color
        .padding()
    }
}


private struct MyCustomView: View {
    var body: some View {
        VStack {
            Button {
                print("Click!")
            } label: {
                Text("Click me")
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }
}

private let previewMarkdown =  #"""
# Header 1

## Header 2

Here is a link: [Apple](https://apple.com). We should also try **bold** to see if it works. Not to mention _italic_ and I guess one more __bold__.

- This is a list item.
    - This is a nested list item.
    - This is also a nested list item. It is a bit longer, to see what happens if a list element occupies multiple lines.
    - Here's yet another nested item.
        - Twice as nested.
- This too, is a list item.
    - Nested list items are fun.

---

1. First of all, let's try a list item.
1. Secondly, this is also a list item. It is a bit longer, to see what happens if a list element occupies multiple lines.
    1. This is a nested item.
    2. Also a nested item.
        - Mixed unordered list here
        - One more item
1. Thirdly, here's another list item.

### Header 3

Let's try some `inline code` here, and maybe some ~~strikethrough~~ while we are at it.

> This is a blockquote. A blockquote is a typographic element used to set apart and visually distinguish a longer quotation or excerpt from the main text.

```swift
// Here's a code block
func fibonacci(n: Int) -> Int {
    var num1 = 0
    var num2 = 1
    for _ in 0 ..< n {
        let num = num1 + num2
        num1 = num2
        num2 = num
    }
    return num2
}
```

This text is before the separator.

## Markdown

Markdown, a lightweight markup language, was created by John Gruber and Aaron Swartz in 2004. The primary goal behind its development was to design a text-to-HTML conversion tool that allowed writers to create content in a simple and readable format, while also being easily converted into valid HTML. Markdown aimed to provide a more intuitive way to write for the web without the complexities of HTML, offering a straightforward syntax that could be easily learned and applied.

The syntax of Markdown was influenced by existing conventions in plain text email, allowing users to create structured documents using simple characters like asterisks, underscores, and dashes. The initial release of Markdown was accompanied by a Perl script called "Markdown.pl," which translated the Markdown syntax into HTML. This script played a pivotal role in popularizing Markdown, making it accessible and usable for a wider audience. Markdown quickly gained traction due to its simplicity and effectiveness, enabling writers to focus on content creation rather than dealing with intricate HTML tags.

Over time, Markdown's popularity grew, and its usage expanded beyond the initial intent of web content creation. Various implementations and parsers emerged, adapting Markdown for different platforms and applications. GitHub, a widely used platform for code hosting and collaboration, played a significant role in Markdown's proliferation. GitHub's support for Markdown made it a de facto standard for documentation within the coding community, further solidifying its position as a versatile and widely adopted markup language.

In 2014, John Gruber formally documented the Markdown syntax in the "Markdown Syntax Documentation," providing a comprehensive reference for users and developers. Despite not being standardized by a formal specification organization, Markdown has become a de facto standard for content creation on the web. Its simplicity, readability, and ease of use have made it a preferred choice for a diverse range of applications, from blogging and documentation to collaborative writing and note-taking tools.

In recent years, various flavors and extensions of Markdown have emerged, introducing additional features and customization options. While some argue that this fragmentation dilutes the simplicity of Markdown, others appreciate the flexibility it offers for different use cases. Overall, the history of Markdown is a testament to the success of creating a markup language that prioritizes simplicity and accessibility, making it a widely adopted and enduring tool for content creation.

---

This text is after the separator.

| Fruit     | Color  | Is it good? |
|-----------|--------|------------:|
| 🍌 Banana | Yellow | Yes         |
| 🍏 Apple  | Green  | Yes         |
| 🍋 Lemon  | Yellow | Not really  |

This is after the table.

Here's a remote image:

![Darth Remote](https://cached-images.bonnier.news/gcs/bilder/dn-mly/5b2cf962-3fa4-4c47-9c5c-2f409466106f.jpeg)

And here's a local image from the asset catalog:

![Darth Local](darthvader)

Here's a custom view:

<view tag="myCustomView"/>

This is just some text after the custom view.
"""#
#endif
