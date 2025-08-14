import SwiftData
//
//  ChatView.swift
//  iChat
//
//  Created by Lion on 2025/4/28.
//
import SwiftUI

struct SessionView: View {
    @Environment(\.modelContext) private var modelContext

    @Bindable var session: ChatSession

    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                SessionDetailView(
                    messages: session.sortedMessages,
                )
                CustomMessageView(message: $session.message)
            }
        }
        .onTapGesture {
            session.message = ""
        }
        .textSelection(.enabled)  // 允许选择文本
        .navigationTitle(session.title.isEmpty ? "New Chat" : session.title)
    }
}
