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
                provider: provider,
                model: model,
                messages: session.sortedMessages,
                temperature: session.temperature
            )
            let assistantMessage = ChatMessage(
                modelName: model.name,
                content: "",
                role: .assistant,
                isStreaming: true,
                session: session
            )

            await MainActor.run{
                modelContext.insert(assistantMessage)
                try? modelContext.save()
            }
            
            try await ResponseContentHelper(message: assistantMessage).contentHelper(stream: stream)
        } catch {
            session.message = String(describing: error)
        }
        
    }

    

}
