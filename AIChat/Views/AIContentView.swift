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
    @State private var isShwoError = false

    @Query(filter: #Predicate<AIModel> { $0.isDefault == true })
    private var models: [AIModel] = []

    @Query var providers: [AIProvider] = []

    @Query(sort: [SortDescriptor(\ChatSession.createdAt, order: .reverse)])
    private var sessions: [ChatSession] = []

    var body: some View {
        NavigationSplitView {
            Divider()
            VStack {
                List(sessions, selection: $selectedSession) { session in
                    Text(session.title.isEmpty ? "New Chat" : session.title)
                        .tag(session)  // 重要: 使用 id 作为 tag
                        .contextMenu {  // 右键菜单删除
                            Button("Delete Chat") {
                                deleteSession(session)
                            }
                        }
                }
                VStack {
                    Menu(getSelectName()) {
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
                        }.frame(maxWidth: .infinity)
                    }.font(.title)
                }
                .padding()
            }
            .navigationTitle("Chat Sessions")
            .navigationSplitViewColumnWidth(min: 180, ideal: 180)
            .toolbar {
                ToolbarItem {
                    Button {
                        if let model = getDefaultModel() {
                            createNewSession(
                                model: model
                            )
                        } else {
                            isShwoError = true
                        }
                    } label: {
                        Label("New Chat", systemImage: "plus.bubble")
                            .foregroundStyle(Color.accentColor)
                    }.alert("Error", isPresented: $isShwoError) {
                        Button("OK") {
                            isShwoError = false
                        }
                    } message: {
                        Text("Please select model").foregroundColor(.red)
                    }
                }
            }

        } detail: {
            if let session = selectedSession {
                AIChatView(session: session)
                    .id(session)  // 重要: 当 sessionId 改变时，强制刷新 ChatView
            } else {
                Text("Select or create a chat session.")
                    .font(.title)
                    .foregroundColor(.secondary)
            }
        }
    }

    /// 创建系统信息
    /// - Parameter session: Session
    private func createSystemMessage(session: ChatSession) {
        guard language != .auto else {
            return
        }
        _ = ChatMessage(
            modelName: "System",
            content: language.content,
            role: .system,
            session: session
        )
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
    private func getSelectName() -> String {
        var name = "Select Model"
        if let model = getDefaultModel() {
            name = model.name
        }
        return name
    }

    // 创建新会话
    private func createNewSession(model: AIModel) {
        if let session = sessions.first(where: { $0.title.isEmpty }) {
            selectedSession = session
            return
        }

        let newSession = ChatSession(model: model)
        createSystemMessage(session: newSession)
        modelContext.insert(newSession)
        do {
            try modelContext.save()  // 保存以获取持久化 ID
            selectedSession = newSession  // 选中新创建的会话
        } catch {
            print("Error saving new session: \(error)")
        }
    }

    // 删除会话
    private func deleteSession(_ session: ChatSession) {
        // 如果删除的是当前选中的会话，取消选中
        if selectedSession == session {
            selectedSession = nil
        }
        modelContext.delete(session)
        try? modelContext.save()
    }
}
