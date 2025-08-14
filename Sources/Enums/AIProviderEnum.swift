//
//  AIProviderIdentifier.swift
//  iChat
//
//  Created by Lion on 2025/4/28.
//


// AI 提供商标识符 (可扩展)
enum AIProviderEnum: String, Codable, CaseIterable, Identifiable {
    case grok = "Grok"
    case openAI = "OpenAI"
    case gemini = "Gemini"
    case deepSeek = "DeepSeek"
    case custom = "Custom(OpenAI)"

    var id: String { self.rawValue }
    var name: String { self.rawValue }
    
    private static let data:[Self:AIProviderEnumModel] = [
        .grok:AIProviderEnumModel.getGrok(),
        .openAI:AIProviderEnumModel.getOpenAI(),
        .gemini:AIProviderEnumModel.getGemini(),
        .deepSeek:AIProviderEnumModel.getDeepSeek(),
        .custom:AIProviderEnumModel.getCustom()
    ]
    

    var data:AIProviderEnumModel {
        Self.data[self]!
    }
    
    
}
