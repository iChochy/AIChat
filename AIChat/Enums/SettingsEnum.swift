//
//  ChatRole.swift
//  AIChat
//
//  Created by Lion on 2025/4/28.
//

import SwiftUI

// 聊天角色
enum SettingsEnum: String, CaseIterable,Identifiable{
    case general
    case provider
    case about
    
    var id: String { rawValue }
    
    private static let data:[Self:SettingsEnumModel] = [
        .general:SettingsEnumModel.getGeneral(),
        .provider:SettingsEnumModel.getProvider(),
        .about:SettingsEnumModel.getAbout()
    ]
    

    var data:SettingsEnumModel {
        Self.data[self]!
    }

}
