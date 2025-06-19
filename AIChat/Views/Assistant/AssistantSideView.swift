//
//  PromptView.swift
//  AIChat
//
//  Created by Lion on 2025/6/9.
//

import SwiftData
import SwiftUI

struct AssistantSideView: View {
    @Environment(\.openWindow) private var openWindow
    
    
    @State private var selectedItem:[UUID:Bool] = [:]

    @Query(filter: #Predicate<Assistant> { $0.isFavorite == true })
    var assistants: [Assistant] = []
    
    var createSession: (Assistant) -> Void
    let assistant = Assistant()

    var body: some View {
        Section {
            Button {
                createSession(assistant)
            } label: {
                HStack {
                    Text("Ask AI Chat")
                    Spacer()
                }.padding(5)
                    .background(selectedItem[assistant.id] ?? false ? Color.blue : Color.clear)
                    .foregroundColor(selectedItem[assistant.id] ?? false ? .white : .primary)
                    .cornerRadius(5)
            }.buttonStyle(.plain)
                .onHover { hover in
                    selectedItem[assistant.id] = hover
                }
            ForEach(assistants) { item in
                Button {
                    selectedItem[item.id] = false
                    createSession(item)
                } label: {
                    HStack{
                        Text(item.title.isEmpty ? "AI Assistant" : item.title)
                        Spacer()
                        Button {
                            item.isFavorite.toggle()
                        } label: {
                            Image(systemName: "heart.slash.circle")
                        }.buttonStyle(.plain)
                            .help("Cancel Favorites")
                            .shadow(radius: 10)
                    }
                    .padding(5)
                        .background(selectedItem[item.id] ?? false ? Color.blue : Color.clear)
                        .foregroundColor(selectedItem[item.id] ?? false ? .white : .primary)
                        .cornerRadius(5)
                }
                .buttonStyle(.plain)
                .onHover { hover in
                        selectedItem[item.id] = hover
                }
            }
        } header: {
            HStack {
                Text("Assistant").font(.title).bold()
                Button {
                    NSApp.activate(ignoringOtherApps: true)
                    openWindow(id: "Assistant")
                } label: {
                    Image(systemName: "ellipsis")
                }.buttonBorderShape(.circle)
                    .help("All assistant information")
            }
        }
    }

}
