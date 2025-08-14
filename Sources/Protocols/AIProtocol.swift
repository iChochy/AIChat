//
//  iChatProtocol.swift
//  iChat
//
//  Created by Lion on 2025/4/28.
//

// AI 客户端协议
protocol AIProtocol {
    
    func streamChatResponse(
        provider:AIProvider,
        model: AIModel,
        messages: [ChatMessage],
        temperature:Double
    ) async throws -> AsyncThrowingStream<Delta, Error>  // 返回文本块的流
    
    
    /// 获取可用模型
    /// - Parameter provider: 服务商信息
    /// - Returns: 模型数据
    func getModels(provider:AIProvider) async throws -> [Model]
}


