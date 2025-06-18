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
final class Prompt {
    var id: UUID = UUID()
    var title: String = ""
    var content: String = ""
    var type: PromptEnum
    var timestamp: Date = Date()
    
    init(title: String,content: String,type: PromptEnum) {
        self.title = title
        self.content = content
        self.type  = type
    }
        
}
