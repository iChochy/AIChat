//
//  ProviderView.swift
//  iChat
//
//  Created by Lion on 2025/5/19.
//

import SwiftData
import SwiftUI

struct ModelAddView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss

    @Bindable var provider: AIProvider

    @State var name: String = ""

    var body: some View {
        GroupBox("Add Model") {
            Form {
                TextField("name", text: $name).textFieldStyle(
                    .roundedBorder
                )
            }.padding()
        }.padding()
        HStack {
            Spacer()
            Button("Close") {
                dismiss()
            }
            Button {
                add()
            } label: {
                Text("Add")
            }.disabled(name == "")
                .keyboardShortcut(.return, modifiers: [])
                .buttonStyle(.borderedProminent)
        }.padding()
    }

    private func add() {
        let model = AIModel(name: name, provider: provider)
        context.insert(model)
        try? context.save()
        dismiss()
    }
}
