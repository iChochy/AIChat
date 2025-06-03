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
final class AIProvider {
    var id: UUID = UUID()
    var title: String = ""
    var APIKey:String = ""
    var APIURL:String = ""
    var type:AIProviderEnum = AIProviderEnum.grok

    @Relationship(deleteRule: .cascade, inverse: \AIModel.provider)
    var models: [AIModel] = []

    var createdAt: Date = Date()

    init(title: String,APIURL: String,type:AIProviderEnum) {
        self.title = title
        self.APIURL = APIURL
        self.type = type
    }
    
}
