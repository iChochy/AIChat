//
//  ChatMessage.swift
//  iChat
//
//  Created by Lion on 2025/4/28.
//

import Foundation
import SwiftData
// 聊天消息模型
@Model
final class ChatMessage {
    var id: UUID = UUID()
    var modelName:String = ""
    var content: String = ""
    var reasoning:String = ""
    var isExpanded:Bool = true
    var role: ChatRoleEnum  // 使用枚举
    var isStreaming: Bool  = false // 标记这条消息是否正在流式接收中
    var session: ChatSession?
    var timestamp: Date = Date()

    init(
        modelName:String,
        content: String,
        role: ChatRoleEnum,
        isStreaming: Bool = false,
        session: ChatSession
    ) {
        self.modelName = modelName
        self.content = content
        self.role = role
        self.isStreaming = isStreaming
        self.session = session
    }

    // 用于 API 请求的便捷字典表示 (根据目标 API 调整)
    var apiRepresentation: [String: String] {
        ["role": self.role.rawValue, "content": self.content]
    }
}
