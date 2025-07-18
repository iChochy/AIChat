import SwiftData
//
//  ChatView.swift
//  AIChat
//
//  Created by Lion on 2025/4/28.
//
import SwiftUI

struct ChatSessionView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var providers: [AIProvider] = []

    @Bindable var session: ChatSession


    var body: some View {
        VStack {
            SessionView(session: session)
            InputAreaView(session:session)
        }
        .onTapGesture {
            session.message = ""
        }
        .textSelection(.enabled)  // 允许选择文本
        .navigationTitle(session.title.isEmpty ? "New Chat" : session.title)
        .toolbar {
            ToolbarItem {
                Menu(getSessionModelName()) {
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

    /// 获取会话模型的名称
    /// - Returns: 模型名称
    private func getSessionModelName() -> String {
        guard let model = session.model else {
            return "Select Model"
        }
        return model.name
    }
}
