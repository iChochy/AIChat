//
//  GrokService.swift
//  AIChat
//
//  Created by Lion on 2025/4/28.
//

import Foundation

/// Grok 客户端实现
class GrokService: AIChatProtocol {
    private let chatPath = "/v1/chat/completions"
    private let modelPath = "/v1/models"
    private let session: URLSession = .shared

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
        let (data, response) = try await URLSession.shared.data(for: request)
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
    )async throws -> AsyncThrowingStream<Delta, Error> {
        guard let provider = model.provider else {
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
        let requestBody = StreamRequestBody(
            model: model.name,
            messages: messages.map({ message in
                message.apiRepresentation
            }),
            temperature: temperature,
            stream: true
        )
        request.httpBody = try JSONEncoder().encode(requestBody)
        // 获取流式响应
        let (bytes, response) = try await session.bytes(
            for: request
        )
        try validateResponse(response)
        return AsyncThrowingStream { continuation in
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
        for try await line in bytes.lines {
            guard line.hasPrefix("data:") else { continue }

            let jsonDataString = line.dropFirst(5).trimmingCharacters(
                in: .whitespacesAndNewlines
            )

            if jsonDataString == "[DONE]" {
                return
            }
            print(jsonDataString)
            guard let jsonData = jsonDataString.data(using: .utf8) else {
                continue
            }
            do {
                let response = try JSONDecoder().decode(
                    APIResponseMessage.self,
                    from: jsonData
                )
                if let content = response.choices?.first?.delta {
                    continuation.yield(content)
                }
            } catch {
                print("JSON 解码错误: \(error) for data: \(jsonDataString)")
                continue
            }
        }
    }
}
