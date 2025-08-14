//
//  Views.swift
//  AIChat
//
//  Created by Lion on 2025/4/25.
//

import SwiftData
import SwiftUI

struct AIContentView: View {
    @AppStorage("language") var language = LanguageEnum.auto
    @Environment(\.modelContext) private var modelContext
    @Environment(\.openWindow) private var openWindow
    @State private var selectedSession: ChatSession?
    @State private var isShowError = false

    @Query(filter: #Predicate<AIModel> { $0.isDefault == true })
    private var models: [AIModel] = []

    @Query var providers: [AIProvider] = []

    @Query(sort: [SortDescriptor(\ChatSession.createdAt, order: .reverse)])
    private var sessions: [ChatSession] = []

    var body: some View {
        NavigationSplitView {
            VStack {
                List(selection: $selectedSession) {
                    AssistantSideView { assistant in
                        createNewSession(assistant: assistant)
                    }
                    SessionSideView{
                        selectedSession = nil
                    }
                }
                VStack {
                    Menu(getDefaultModelName()) {
                        ForEach(providers) { provider in
                            Menu(provider.title) {
                                ForEach(provider.models) { model in
                                    Button {
                                        setDefaultModel(model: model)
                                    } label: {
                                        Text(model.name)
                                    }
                                }
                            }
                        }
                    }
                    Divider()
                    Button {
                        NSApp.activate(ignoringOtherApps: true)
                        openWindow(id: "Settings")
                    } label: {
                        HStack {
                            Image(systemName: "gear")
                                .foregroundStyle(Color.accentColor)
                            Text("Settings")
                            Spacer()
                        }.font(.title2)
                    }
                    .buttonStyle(.plain)
                    .padding(.top,5)
                }
                .padding()
            }
            .navigationTitle("Chat Sessions")
            .navigationSplitViewColumnWidth(min: 180, ideal: 180)
            .toolbar {
                ToolbarItem {
                    Button {
                        createNewSession()
                    } label: {
                        Label("New Chat", systemImage: "plus.bubble")
                            .foregroundStyle(Color.accentColor)
                    }.alert("Error", isPresented: $isShowError) {
                        Button("OK") {
                            isShowError = false
                        }
                    } message: {
                        Text("Please select default model").foregroundColor(
                            .red
                        )
                    }
                }
            }

        } detail: {
            if let session = selectedSession {
                ChatSessionView(session: session)
                    .id(session)  // 重要: 当 sessionId 改变时，强制刷新 ChatView
            }
        }.onAppear {
            createNewSession()
        }
    }

    /// 创建系统信息
    /// - Parameter session: Session
    ///
    private func createSystemMessage(session: ChatSession) {
        let systemMessage = ChatMessage(
            modelName: ChatRoleEnum.system.rawValue,
            content: language.content,
            role: .system,
            session: session
        )
        modelContext.insert(systemMessage)
    }

    /// 设置默认模型
    /// - Parameter model: 选择的模型
    private func setDefaultModel(model: AIModel) {
        if let defaultModel = getDefaultModel() {
            defaultModel.isDefault = false
        }
        model.isDefault = true
        try? modelContext.save()
    }

    /// 获取默认模型
    /// - Returns: 默认模型
    private func getDefaultModel() -> AIModel? {
        if let defaultModel = models.first {
            return defaultModel
        }
        return nil
    }

    /// 获取默认模型的名字
    /// - Returns: 默认模型的名字
    private func getDefaultModelName() -> String {
        var name = "Select Default Model"
        if let model = getDefaultModel() {
            name = model.name
        }
        return name
    }

    private func createNewSession(assistant: Assistant) {
        if let model = assistant.model {
            createNewSession(model: model, assistant: assistant)
            return
        }
        if let model = getDefaultModel() {
            createNewSession(model: model, assistant: assistant)
            return
        }
        isShowError = true
    }

    private func createNewSession() {
        if let model = getDefaultModel() {
            let session = createNewSession(
                model: model
            )
            selectedSession = session
        } else {
            isShowError = true
        }
    }

    @MainActor
    private func createNewSession(model: AIModel, assistant: Assistant) {
        let session = createNewSession(model: model)
        session.temperature = assistant.temperature
        if let model = assistant.model {
            session.model = model
        }
        if let message = session.messages.first {
            message.content.append(assistant.prompt)
        }
        selectedSession = session
    }
    // 创建新会话

    @MainActor
    private func createNewSession(model: AIModel) -> ChatSession {
        if let session = sessions.first(where: { $0.title.isEmpty }) {
            modelContext.delete(session)
            try? modelContext.save()  // 保存以获取持久化 ID
        }
        let newSession = ChatSession(model: model)
        modelContext.insert(newSession)
        try? modelContext.save()  // 保存以获取持久化 ID
        createSystemMessage(session: newSession)
        return newSession
    }

}
