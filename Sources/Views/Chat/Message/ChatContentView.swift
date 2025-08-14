//
//  ChatReasoning.swift
//  iChat
//
//  Created by Lion on 2025/5/30.
//

import SwiftUI

// 内容 View
struct ChatContentView: View {
    var message: ChatMessage

    var body: some View {
        HStack {
            switch message.role {
            case .system:
                Text(message.content)
                    .fixedSize(horizontal: false, vertical: true)
                    .background(messageBackgroundColor)
                    .foregroundStyle(messageForegroundColor)
                    .cornerRadius(20)
            case .user:
                Text(message.content)
                    .padding(10)
                    .fixedSize(horizontal: false, vertical: true)
                    .background(messageBackgroundColor)
                    .foregroundStyle(messageForegroundColor)
                    .cornerRadius(20)
            case .assistant:
                Markdown(toMarkdown(), lazy: true)
//                    .padding()
//                    .fixedSize(horizontal: false, vertical: true)
//                    .background(messageBackgroundColor)
//                    .foregroundStyle(messageForegroundColor)
//                    .cornerRadius(30)
            }
        }
    }

    private func toMarkdown() -> MarkdownDocument {
        do {
            return try MarkdownDocument(message.content)
        } catch {
            print(error)
        }
        return try! MarkdownDocument("")
    }

    // 根据角色决定背景色
    private var messageBackgroundColor: Color {
        switch message.role {
        case .user: return Color.accentColor
        case .assistant: return Color.gray.opacity(0.3)
        case .system: return Color.orange.opacity(0.3)
        }
    }

    // 根据角色决定前景色
    private var messageForegroundColor: Color {
        switch message.role {
        case .user: return .white
        default: return .primary  // 自动适应浅色/深色模式
        }
    }

    private func convertMarkdown(content: String) -> AttributedString {
        do {
            let attributedString = try AttributedString(
                markdown: content,
                options: .init(
                    interpretedSyntax: .inlineOnlyPreservingWhitespace
                )
            )
            return attributedString
        } catch {
            print(error)
        }
        return AttributedString("")

    }

}
