//
//  PromptView.swift
//  iChat
//
//  Created by Lion on 2025/6/9.
//

import SwiftData
import SwiftUI

struct AssistantView: View {
    @Environment(\.modelContext) private var modelContext

    @Query var assistants: [Assistant] = []

    @State var editAssistant: Assistant?
    @State var addAssistant: Assistant?

    let gridLayout = [
        GridItem(.adaptive(minimum: 400), spacing: 20)  // 最小宽度为150，列间距20
    ]

    var body: some View {
        ScrollView {
            VStack{
                HStack {
                    Text("AI Assistants")
                        .font(.title)
                        .bold()
                    Button {
                        createAssistant()
                    } label: {
                        Label("Plus", systemImage: "plus")
                    }.buttonBorderShape(.circle)
                        .sheet(item: $addAssistant) { item in
                            AssistantAddView(assistant: item)
                        }
                }
                Divider()
                    .shadow(radius: 10)
                LazyVGrid(columns: gridLayout) {
                    ForEach(assistants) { item in
                        HStack {
                            Image(systemName: "bookmark.circle")
                                .font(.system(size: 40))
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(item.title)
                                        .font(.title3)
                                        .bold()
                                        .lineLimit(1)
                                    if let model = item.model {
                                        Text("(\(model.name))")
                                    }
                                }
                                Divider()
                                Text(item.prompt).lineLimit(1)
                            }
                            VStack(spacing: 5) {
                                Button {
                                    item.isFavorite.toggle()
                                } label: {
                                    Image(
                                        systemName: item.isFavorite
                                        ? "heart.slash.circle" : "heart.circle"
                                    )
                                }.help(
                                    item.isFavorite
                                    ? "Cancel Favorites" : "Favorites"
                                )
                                Button {
                                    editAssistant = item
                                } label: {
                                    Image(systemName: "pencil.circle")
                                }.help("Edit assistant")
                                    .padding(.leading, 30)
                                Button {
                                    deleteAssistant(assistant: item)
                                } label: {
                                    Image(systemName: "minus.circle")
                                }.help("Delete assistant")
                            }.buttonStyle(.plain)
                        }
                        .padding(10)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(50)
                    }
                }.textSelection(.disabled)
                    .sheet(item: $editAssistant) { item in
                        AssistantEditView(assistant: item)
                    }
            }.padding()
        }
    }

    private func createAssistant() {
        addAssistant = Assistant()
    }

    private func favoriteAssistant(assistant: Assistant) {
        assistant.isFavorite = true
        try? modelContext.save()
    }

    private func deleteAssistant(assistant: Assistant) {
        modelContext.delete(assistant)
        try? modelContext.save()
    }
}
