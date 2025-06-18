//
//  SettingsModel.swift
//  AIChat
//
//  Created by Lion on 2025/5/19.
//

import Foundation
import SwiftUI

class PromptEnumModel {
    var icon: String = ""
    var title: String = ""
    var color: Color = Color.accentColor
    
    init(icon: String, title: String, color: Color) {
        self.icon = icon
        self.title = title
        self.color = color
    }
    
    
    static func getGeneral() -> PromptEnumModel{
        return PromptEnumModel(icon: "", title: "general", color: .green)
    }
    
    static func getSystem() -> PromptEnumModel{
        return PromptEnumModel(icon: "", title: "system", color: .accentColor)
    }
    
    static func getCustom() -> PromptEnumModel{
        return PromptEnumModel(icon: "", title: "custom", color: .pink)
    }
    
    
}
