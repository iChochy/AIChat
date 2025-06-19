//
//  MessageListView.swift
//  AIChat
//
//  Created by Lion on 2025/4/30.
//

import SwiftData
import SwiftUI

// MARK: - Message List View
struct SessionDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let messages: [ChatMessage]

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(messages) { message in
                        ChatMessageView(message: message).id(message)
                    }
                }
                .padding()
            }.onChange(of: messages) { oldValue, newValue in
                if oldValue.count < newValue.count {
                    scrollView(
                        proxy: proxy,
                        message: messages.last,
                        anchor: .bottom
                    )
                }
            }.onAppear {
                scrollView(
                    proxy: proxy,
                    message: messages.last,
                    anchor: .bottom
                )
            }
            //            .scrollClipDisabled()
            .toolbar {
                if messages.count > 0 {
                    TOCToolbarItemView(messages: messages, proxy: proxy)
                }
            }
        }
    }

    private func scrollView(
        proxy: ScrollViewProxy,
        message: ChatMessage?,
        anchor: UnitPoint
    ) {
        proxy.scrollTo(message, anchor: anchor)
    }

}
