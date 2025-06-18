//
//  ChatReasoning.swift
//  AIChat
//
//  Created by Lion on 2025/5/30.
//

import SwiftUI

// 推理 View
struct ChatReasoningView: View {
    var message: ChatMessage

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    withAnimation {
                        message.isExpanded.toggle()
                    }
                }) {
                    HStack {
                        Image(
                            systemName: message.isExpanded
                                ? "chevron.down" : "chevron.right"
                        ).frame(width: 5)
                        Text("Thinking")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            if message.isExpanded {
                GroupBox{
                    Markdown(toMarkdown(), lazy: true)
                }
            }
        }.frame(maxWidth: 400)
    }
    
    private func toMarkdown() -> MarkdownDocument {
        do {
            return try MarkdownDocument(message.reasoning)
        } catch {
            print(error)
        }
        return try! MarkdownDocument("")
    }
    

    private func convertMarkdown() -> AttributedString {
        do {
            let attributedString = try AttributedString(
                markdown: message.reasoning,
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
