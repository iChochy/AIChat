//
//  GrokService.swift
//  AIChat
//
//  Created by Lion on 2025/4/28.
//

import Foundation

/// Gemini 客户端实现
class GeminiService: AIChatProtocol {
    
    private let chatPath = "/v1beta/openai/chat/completions"
    private let modelPath = "/v1beta/openai/models"
    private let session: URLSession = .shared

    //    init(session: URLSession = .shared) {
    //        self.session = session
    //    }

    func getModels(provider: AIProvider) async throws -> [Model] {
        guard let APIURL = URL(string: provider.APIURL + modelPath) else {
            throw AIError.WrongAPIURL
        }
        // 构建请求
        var request = URLRequest(url: APIURL)
        request.httpMethod = "GET"
        request.setValue(
            "Bearer \(provider.APIKey)",
            forHTTPHeaderField: "Authorization"
        )
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        let (data, response) = try await session.data(for: request)
//        print(String(data: data, encoding: .utf8))
        try validateResponse(response)
        let modelResponse = try JSONDecoder().decode(
            ModelResponse.self,
            from: data
        )
        return modelResponse.data
    }

    
    
    
    func streamChatResponse(
        provider:AIProvider,
        model: AIModel,
        messages: [ChatMessage],
        temperature:Double
    ) async throws -> AsyncThrowingStream<Delta, Error>  {
        guard let provider = model.provider else{
            throw AIError.MissingProvider
        }
        guard
            let APIURL = URL(string: provider.APIURL + chatPath)
        else {
            throw AIError.WrongAPIURL
        }
        // 构建请求
        var request = URLRequest(url: APIURL)
        request.httpMethod = "POST"
        request.setValue(
            "Bearer \(provider.APIKey)",
            forHTTPHeaderField: "Authorization"
        )
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        // 构建请求体
        var requestBody = StreamRequestBody(
            model: model.name,
            messages: messages.map({ message in
                message.apiRepresentation
            }),
            temperature: temperature,
            stream: true
        )
        requestBody.extraBody = ExtraBody(google: Google(thinkingConfig: ThinkingConfig()))
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        // 获取流式响应
        let (bytes, response) = try await session.bytes(
            for: request
        )
        
        try validateResponse(response)
        
       return  AsyncThrowingStream { continuation in
            Task {
                do {
                    // 处理 SSE 流
                    try await processStream(
                        bytes: bytes,
                        continuation: continuation
                    )
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }



    // 处理 SSE 流
    private func processStream(
        bytes: URLSession.AsyncBytes,
        continuation: AsyncThrowingStream<Delta, Error>.Continuation
    ) async throws {
        var isThinking = false
        for try await line in bytes.lines {
            print(line)
            guard line.hasPrefix("data:") else { continue }

            let jsonDataString = line.dropFirst(5).trimmingCharacters(
                in: .whitespacesAndNewlines
            )

            if jsonDataString == "[DONE]" {
                return
            }

            guard let jsonData = jsonDataString.data(using: .utf8) else {
                continue
            }

            do {
                let response = try JSONDecoder().decode(
                    APIResponseMessage.self,
                    from: jsonData
                )
                if let content = response.choices?.first?.delta {
                    let content = transformThinking(delta: content,isThinking:&isThinking)
                    continuation.yield(content)
                }
            } catch {
                print("JSON 解码错误: \(error) for data: \(jsonDataString)")
                continue
            }
        }
    }
    
    private func transformThinking(delta:  Delta,isThinking: inout Bool) -> Delta{
        guard var  content = delta.content else {
            return delta
        }
        if content.contains("<thought>") {
            isThinking = true
            content.removeAll{ "<thought>".contains($0) }
        }else if content.contains("</thought>") {
            isThinking = false
            content.removeAll { content in
                "</thought>".contains(content)
            }
        }
        let delta = Delta(
                content: isThinking ? nil : content,
                reasoning: isThinking ? content : nil
            )
        return delta
    }
}

