//
//  ChatReasoning.swift
//  AIChat
//
//  Created by Lion on 2025/5/30.
//

import SwiftUI

// 内容 View
struct ChatOperationView: View {
    @Environment(\.modelContext) private var modelContext
    var message: ChatMessage

    var body: some View {
        Text(
            "\(message.timestamp, style: .date) \(message.timestamp, style: .time)"
        )
        .font(.caption)
        .foregroundColor(.gray)
        HStack {
            ShareLink(item: message.content) {
                Image(systemName: "square.and.arrow.up")
            }
            Button {
                copyMessage()
            } label: {
                Image(systemName: "document.on.document")
            }
            Button {
                deleteMessage()
            } label: {
                Image(systemName: "trash")
            }
        }.buttonBorderShape(.circle)
        HStack {
            Spacer()
        }
    }

    private func copyMessage() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(message.content, forType: .string)
    }

    private func deleteMessage() {
        withAnimation {
            modelContext.delete(message)
            try? modelContext.save()
        }
    }

}
