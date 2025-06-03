//
//  SettingsModel.swift
//  AIChat
//
//  Created by Lion on 2025/5/19.
//

import Foundation
import SwiftUI

class AIProviderEnumModel {
    var title: String = ""
    var icon: String = ""
    var APIURL:String = ""
    var service:AIChatProtocol = GrokService()
    
    init(title: String, icon: String, APIURL: String,service:AIChatProtocol) {
        self.title = title
        self.icon = icon
        self.APIURL = APIURL
        self.service = service
    }
    
    
    static func getGrok() -> AIProviderEnumModel{
        let title = "Grok(XAI)"
        let icon = ""
        let APIURL = "https://api.x.ai"
        let service = GrokService()
        return AIProviderEnumModel(title: title, icon: icon, APIURL: APIURL,service:service)
    }
    
    static func getOpenAI() -> AIProviderEnumModel{
        let title = "OpenAI"
        let icon = ""
        let APIURL = "https://api.openai.com"
        let service = GrokService()
        return AIProviderEnumModel(title: title, icon: icon, APIURL: APIURL,service:service)
    }
    
    static func getGemini() -> AIProviderEnumModel{
        let title = "Gemini"
        let icon = ""
        let APIURL = "https://generativelanguage.googleapis.com"
        let service = GeminiService()
        return AIProviderEnumModel(title: title, icon: icon, APIURL: APIURL,service:service)
    }
    static func getDeepSeek() -> AIProviderEnumModel{
        let title = "DeepSeek"
        let icon = ""
        let APIURL = "https://api.deepseek.com"
        let service = DeepSeekService()
        return AIProviderEnumModel(title: title, icon: icon, APIURL: APIURL,service:service)
    }
    static func getCustom() -> AIProviderEnumModel{
        let title = "Custom(OpenAI)"
        let icon = ""
        let APIURL = ""
        let service = GrokService()
        return AIProviderEnumModel(title: title, icon: icon, APIURL: APIURL,service:service)
    }
    
}
