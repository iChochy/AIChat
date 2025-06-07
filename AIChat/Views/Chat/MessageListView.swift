//
//  MessageListView.swift
//  AIChat
//
//  Created by Lion on 2025/4/30.
//

import SwiftData
import SwiftUI

// MARK: - Message List View
struct MessageListView: View {
    let messages: [ChatMessage]

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(messages) { message in
                        ChatMessageView(message: message).id(message)
                    }
                }
                .padding()
            }.onChange(of: messages.count) {
                scrollViewToBotton(proxy: proxy)
            }.onAppear {
                scrollViewToBotton(proxy: proxy)
            }.scrollClipDisabled()
        }
    }

    private func scrollViewToBotton(proxy: ScrollViewProxy) {
        withAnimation(.default) {
            proxy.scrollTo(messages.last, anchor: .bottom)
        }
    }
}
