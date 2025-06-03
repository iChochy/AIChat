//
//  ChatSession.swift
//  AIChat
//
//  Created by Lion on 2025/4/28.
//

import Foundation
import SwiftData

// 聊天会话模型
@Model
final class ChatSession {
    var id: UUID = UUID()
    var title: String = ""
    
    var message:String = ""
    
    var model: AIModel?

    // 与 ChatMessage 的关系 (一对多), 按时间戳排序
    @Relationship(deleteRule: .cascade, inverse: \ChatMessage.session)
    var messages: [ChatMessage] = []  // 初始化为空数组

    var createdAt: Date = Date()
    
    init(model: AIModel) {
        self.model = model
    }

    // 按时间戳排序消息的计算属性 (方便 UI 使用)
    var sortedMessages: [ChatMessage] {
        messages.sorted { $0.timestamp < $1.timestamp }
    }
}
