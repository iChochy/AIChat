//
//  ProviderView.swift
//  iChat
//
//  Created by Lion on 2025/5/19.
//

import SwiftData
import SwiftUI

struct ProviderView: View {
    let title = "Provider"
    let icon = "server.rack"

    @State var APIKey: String = ""
    @Environment(\.modelContext) private var context

    @State var selectModel: AIModel?

    @State private var selectedProvider: String = "选择 AI 提供商"

    @Query
    var providers: [AIProvider] = []

    var body: some View {
        List(content: {
            ForEach(providers) { item in
                ProviderEditorView(provider: item)
            }
        }).scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItemGroup {
                    Menu {
                        ForEach(AIProviderEnum.allCases) { item in
                            Button {
                                addProvider(type: item)
                            } label: {
                                HStack {
                                    Image(systemName: "plus").foregroundStyle(
                                        Color.accentColor
                                    )
                                    Text(item.data.title)
                                }
                            }
                        }
                    } label: {
                        Label("Plus", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Provider")
    }

    private func addProvider(type: AIProviderEnum) {
        let model = type.data
        let provider = AIProvider(
            title: model.title,
            APIURL: model.APIURL,
            type: type
        )
        context.insert(provider)
        try? context.save()
    }
}
