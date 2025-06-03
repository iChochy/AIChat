
//
//  ChatView.swift
//  AIChat
//
//  Created by Lion on 2025/4/28.
//
import SwiftUI
import SwiftData

struct AIChatView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var providers: [AIProvider] = []
    
    @Bindable var session: ChatSession
    
    @StateObject private var viewModel = ChatViewModel()
    
    
    var body: some View {
        VStack(spacing: 0) {
            MessageListView(
                messages: session.sortedMessages,
            )
            Text(session.message).foregroundStyle(.red).padding()
            InputAreaView(
                userInput: $viewModel.userInput,
                isSending: viewModel.isSending,
                sendAction: viewModel.sendMessage
            )
        }
        .navigationTitle(session.title.isEmpty ?  "New Chat" : session.title)
        .onAppear {
            viewModel.setup(modelContext: modelContext,session: session)
        }.toolbar {
            ToolbarItem {
                Menu(getModelName()) {
                    ForEach(providers) { provider in
                        Menu(provider.title) {
                            ForEach(provider.models) { model in
                                Button {
                                    setSessionModel(model: model)
                                } label: {
                                    Text(model.name)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    /// 设置会话模型
    /// - Parameter model: 选择的模型
    private func setSessionModel(model: AIModel) {
        session.model = model
        try? modelContext.save()
    }
    
    private func getModelName() -> String {
        guard let model = session.model else {
            return "Select Model"
        }
        return model.name
    }
    
}

