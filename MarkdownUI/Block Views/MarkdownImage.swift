import SwiftUI

struct MarkdownImage: View {

    private let text: AttributedString
    private let url: URL

    @Environment(\.markdownStyle) private var style

    init(_ image: MarkdownBlock.Image) {
        self.text = image.text
        self.url = image.url
    }

    var body: some View {
        if url.scheme == "https" {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(style.image.cornerRadius)
            } placeholder: {
                VStack {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 100)
            }
            .padding(.top, style.image.padding.top)
            .padding(.bottom, style.image.padding.bottom)
        } else {
            Image(path(from: url), bundle: style.image.bundle)
                .resizable()
                .scaledToFit()
                .cornerRadius(style.image.cornerRadius)
                .padding(.top, style.image.padding.top)
                .padding(.bottom, style.image.padding.bottom)
        }
    }

    private func path(from: URL) -> String {
        if #available(iOS 16.0, macOS 13.0, *) {
            return url.path(percentEncoded: false)
        } else {
            return url.path
        }
    }
}
