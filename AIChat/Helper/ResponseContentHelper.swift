//
//  ResponseContentHelper.swift
//  AIChat
//
//  Created by OSX on 2025/6/20.
//

import Foundation


class ResponseContentHelper{
    let message:ChatMessage
    var totalCount = 1
    var accumulatedContent = ""
    var accumulatedReasoning = ""
        
    init(message: ChatMessage) {
        self.message = message
    }
    
    func contentHelper(stream:AsyncThrowingStream<Delta, Error>) async throws {
        for try await chunk in stream {
            setReasoning(reasoning: chunk.reasoning)
            setContent(content: chunk.content)
        }
        // 处理剩余的积累内容，最后追加信息
        if !accumulatedContent.isEmpty {
            message.content.append(accumulatedContent)
            accumulatedContent = ""
        }
        message.isStreaming = false
        print(totalCount)
    }
    

    func setReasoning(reasoning:String?){
        if let reasoning = reasoning {
            accumulatedReasoning.append(reasoning)
            if accumulatedReasoning.count > totalCount {
                message.reasoning.append(accumulatedReasoning)
                accumulatedReasoning = ""
                totalCount += 1
                //                        try await Task.sleep(nanoseconds: 300_000_000)
            }
            // 处理剩余的积累内容
        } else if !accumulatedReasoning.isEmpty {
            message.reasoning.append(accumulatedReasoning)
            accumulatedReasoning = ""
        }
    }
    
    
    func setContent(content:String?){
        if let content = content {
            accumulatedContent.append(content)
            if accumulatedContent.count > totalCount {
                message.content.append(accumulatedContent)
                accumulatedContent = ""
                totalCount += 1
                //                        try await Task.sleep(nanoseconds: 300_000_000)
            }
            // 处理剩余的积累内容
        }else if !accumulatedContent.isEmpty {
            message.content.append(accumulatedContent)
            accumulatedContent = ""
        }
    }
    
    private func setReasoning(message: ChatMessage, reasoning: String?) {
        if let reasoning = reasoning {
            message.reasoning.append(contentsOf: reasoning)
        }
    }

    private func setContent(message: ChatMessage, content: String?) {
        if let content = content {
            message.content.append(contentsOf: content)
        }
    }
    
}
