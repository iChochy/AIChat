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
                }.id("VStack").padding()
            }.onChange(of: messages.count) { oldValue, newValue in
                    scrollViewToBotton(proxy: proxy)
            }.onAppear {
                scrollViewToBotton(proxy: proxy)
            }
        }
    }

    private func scrollViewToBotton(proxy: ScrollViewProxy) {
        withAnimation {
            proxy.scrollTo(messages.last, anchor: .bottom)
        }
    }
}
