//
//  ChatSession.swift
//  AIChat
//
//  Created by Lion on 2025/4/28.
//

import Foundation
import SwiftData

// 智能助手
@Model
final class Assistant {
    var id: UUID = UUID()
    var title: String = ""
    var desc:String = ""
    var temperature:Double  = 1.0
    var prompt: String = ""
    var isFavorite: Bool = true
    var model:AIModel?
    var timestamp: Date = Date()
    
    init() {}
}

