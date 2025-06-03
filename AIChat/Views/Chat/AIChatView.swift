import SwiftData
//
//  ChatView.swift
//  AIChat
//
//  Created by Lion on 2025/4/28.
//
import SwiftUI

struct AIChatView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var providers: [AIProvider] = []

    @Bindable var session: ChatSession

    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                MessageListView(
                    messages: session.sortedMessages,
                )
                if !session.message.isEmpty {
                    Text(session.message)
                        .bold()
                        .padding()
                        .foregroundStyle(.red)
                        .background(.black.opacity(0.5))
                        .cornerRadius(50)
                        .shadow(radius: 10)
                        .padding()

                }
            }
            InputAreaView(
                userInput: $viewModel.userInput,
                isSending: viewModel.isSending,
                sendAction: viewModel.sendMessage
            )
        }
        .onTapGesture {
            session.message = ""
        }
        .animation(.default, value: session.message)
        .textSelection(.enabled)  // 允许选择文本
        .navigationTitle(session.title.isEmpty ? "New Chat" : session.title)
        .onAppear {
            viewModel.setup(modelContext: modelContext, session: session)
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
