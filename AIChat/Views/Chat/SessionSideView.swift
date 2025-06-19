//
//  PromptView.swift
//  AIChat
//
//  Created by Lion on 2025/6/9.
//

import SwiftData
import SwiftUI

struct SessionSideView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: [SortDescriptor(\ChatSession.createdAt, order: .reverse)])
    private var sessions: [ChatSession] = []
    var deleteSession: () -> Void

    var body: some View {
        Section {
            ForEach(sessions) { session in
                Text(
                    session.title.isEmpty
                        ? "New Chat" : session.title
                )
                .tag(session)  // 重要: 使用 id 作为 tag
                .contextMenu {  // 右键菜单删除
                    Button {
                        deleteSession(session)
                    } label: {
                        Image(systemName: "trash")
                        Text("Delete Chat")
                    }
                }
            }
        } header: {
            Text("Session").font(.title).bold()
        }
    }

    // 删除会话
    private func deleteSession(_ session: ChatSession) {
        modelContext.delete(session)
        try? modelContext.save()
        deleteSession()
    }

}
