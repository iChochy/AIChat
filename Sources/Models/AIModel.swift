//
//  ChatSession.swift
//  iChat
//
//  Created by Lion on 2025/4/28.
//

import Foundation
import SwiftData

// 聊天会话模型
@Model
final class AIModel { 
    var id: UUID = UUID()
    var name: String = ""
    var isDefault: Bool = false
    
    var provider: AIProvider?
    
    @Relationship(deleteRule: .nullify, inverse: \ChatSession.model)
    var sessions: [ChatSession] = []
    
    @Relationship(deleteRule: .nullify, inverse: \Assistant.model)
    var assistant: Assistant?
    
    var createdAt: Date = Date()
    
    init(name: String,provider:AIProvider) {
        self.name = name
        self.provider = provider
    }
}
