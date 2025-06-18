//
//  ChatRole.swift
//  AIChat
//
//  Created by Lion on 2025/4/28.
//

import SwiftUI

// 提示词枚举
enum PromptEnum: String, Codable, CaseIterable, Identifiable{
    case general
    case system
    case custom
    
    var id: Self { self }
    
    private static let data:[Self:PromptEnumModel] = [
        .general:PromptEnumModel.getGeneral(),
        .system:PromptEnumModel.getSystem(),
        .custom:PromptEnumModel.getCustom()
    ]
    

    var data:PromptEnumModel {
        Self.data[self]!
    }

}
