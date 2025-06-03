//
//  ServiceView.swift
//  AIClient
//
//  Created by Lion on 2025/5/19.
//

import SwiftData
import SwiftUI

struct ServiceModelEditorView: View {
    @Environment(\.modelContext) private var context

    @Bindable var provider: AIProvider

    @State var isPresented = false
    @State var name: String = ""

    var body: some View {
        Section {
            ForEach(provider.models) { item in
                HStack {
                    Text(item.name).tag(item)
                    Spacer()
                    Button {
                        delete(model: item)
                    } label: {
                        Image(systemName: "minus")
                    }.buttonBorderShape(.circle)
                }
            }
        } header: {
            HStack {
                Text("Models").font(.title2)
                Button {
                    fetch()
                } label: {
                    Label("fetch", systemImage: "square.and.arrow.down")
                }.disabled(provider.APIKey.isEmpty || provider.APIURL.isEmpty)
                    .buttonStyle(.borderedProminent)
                Spacer()
                Button {
                    show()
                } label: {
                    Image(systemName: "plus")
                }.buttonBorderShape(.circle)
                    .background(Color.accentColor)
                    .clipShape(.circle)
                    .sheet(
                        isPresented: $isPresented,
                        onDismiss: {
                            name = ""
                        }
                    ) {
                        GroupBox("Add Model") {
                            Form {
                                TextField("name", text: $name).textFieldStyle(
                                    .roundedBorder
                                )
                                HStack {
                                    Spacer()
                                    Button {
                                        add()
                                    } label: {
                                        Label("Add", systemImage: "plus")
                                    }.disabled(name == "")
                                        .keyboardShortcut(.return,modifiers:[])
                                        .buttonStyle(.borderedProminent)
                                }
                            }.padding()
                        }.padding()
                    }
            }
            Divider()
        }
    }

    private func fetch() {

    }

    private func delete(model: AIModel) {
        context.delete(model)
        try? context.save()
    }
    private func show() {
        isPresented.toggle()
    }
    private func add() {
        isPresented.toggle()
        let model = AIModel(name: name, isSystem: false, provider: provider)
        context.insert(model)
        try? context.save()
    }
}
