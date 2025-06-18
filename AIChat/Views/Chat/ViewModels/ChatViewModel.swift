//
//  ChatViewModel.swift
//  AIChat
//
//  Created by Lion on 2025/4/30.
//

import SwiftData
import SwiftUI

// MARK: - View Model
@MainActor
class ChatViewModel: ObservableObject {
    private var modelContext:ModelContext?
    private var session:ChatSession?
    @AppStorage("language") var language = LanguageEnum.auto
    @Published var userInput: String = ""
    @Published var isSending: Bool = false
    @AppStorage("nickname") var nickname = "AI Chat"
    

    func sendMessage(session:ChatSession,modelContext:ModelContext) {
        let userContent = userInput.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        guard
            !userContent.isEmpty,
            !isSending
        else { return }

        userInput = ""
        isSending = true

        let userMessage = ChatMessage(
            modelName: nickname,
            content: userContent,
            role: .user,
            session: session
        )
        
        if session.title.isEmpty {
            session.title = userContent
        }
        session.message = ""

        modelContext.insert(userMessage)
        try? modelContext.save()

        Task {
            await handleAIResponse(session: session,modelContext:modelContext)
        }
    }

    private func handleAIResponse(session:ChatSession,modelContext:ModelContext) async {
        defer{
            isSending = false
        }


        guard let model = session.model else {
            session.message = "Please select model!"
            return
        }

        guard let provider = model.provider else {
            session.message =  String(describing: AIError.MissingProvider)
            return
        }

        do {            
            let stream = try await provider.type.data.service.streamChatResponse(
                model: model,
                messages: session.sortedMessages
            )
            
            let assistantMessage = ChatMessage(
                modelName: model.name,
                content: "",
                role: .assistant,
                isStreaming: true,
                session: session
            )
            
            // 积累内容和推理的缓冲区
            var accumulatedContent = ""
            var accumulatedReasoning = ""
            var totalCount = 0

            for try await chunk in stream {
                if let reasoning = chunk.reasoning {
                    accumulatedReasoning.append(reasoning)
                    if accumulatedReasoning.count > totalCount {
                        assistantMessage.reasoning.append(accumulatedReasoning)
                        accumulatedReasoning = ""
                        //                        try await Task.sleep(nanoseconds: 300_000_000)
                        totalCount += 10
                    }
                    // 处理剩余的积累内容
                } else if !accumulatedReasoning.isEmpty {
                    assistantMessage.reasoning.append(accumulatedReasoning)
                    accumulatedReasoning = ""
                }

                if let content = chunk.content {
                    accumulatedContent.append(content)
                    if accumulatedContent.count > totalCount {
                        assistantMessage.content.append(accumulatedContent)
                        accumulatedContent = ""
                        //                        try await Task.sleep(nanoseconds: 300_000_000)
                        totalCount += 10
                    }
                }
            }
            print(totalCount)

            // 处理剩余的积累内容
            if !accumulatedContent.isEmpty {
                assistantMessage.content.append(accumulatedContent)
            }

            assistantMessage.isStreaming = false
            modelContext.insert(assistantMessage)
            try? modelContext.save()
        } catch {
            session.message = String(describing: error)
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
