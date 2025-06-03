import SwiftData
//
//  ChatMessageView.swift
//  AIChat
//
//  Created by Lion on 2025/4/28.
//
import SwiftUI

// 单条消息视图
struct ChatMessageView: View {

    let message: ChatMessage

    var body: some View {
        if message.role == .system {
            Text(message.content).foregroundStyle(.gray.opacity(0.5))
        }else{
            VStack(alignment: message.role == .user ? .trailing : .leading) {
                HStack {
                    Text(message.modelName)
                        .bold()
                        .font(.title3)
                        .foregroundColor(.gray)
                    if message.isStreaming {
                        ProgressView().controlSize(.mini)  // 显示流式指示器
                    }
                }
                if !message.reasoning.isEmpty {
                    ChatReasoningView(message: message)
                }
                if !message.content.isEmpty {
                    ChatContentView(message: message)
                }
                ChatOperationView(message: message)
            }.textSelection(.enabled)  // 允许选择文本
                .opacity(message.isStreaming ? 0.7 : 1.0)  // 流式消息可以稍微透明
                .frame(maxWidth: .infinity)
        }
        
    }


}
