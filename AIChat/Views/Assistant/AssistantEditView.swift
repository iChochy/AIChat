//
//  PromptView.swift
//  AIChat
//
//  Created by Lion on 2025/6/9.
//

import SwiftData
import SwiftUI

struct AssistantEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @Query var providers: [AIProvider] = []
    
    @Query var assistants: [Assistant] = []

    @State var selectedAssistant: Assistant?

    @State var isPresentedAssistantAdd = false

    @Bindable var assistant: Assistant

    var body: some View {
        GroupBox {
            VStack {
                Form {
                    TextField(
                        "Title",
                        text: $assistant.title,
                        prompt: Text("Title")
                    )
                    TextField(
                        "Description",
                        text: $assistant.desc,
                        prompt: Text("Description")
                    )
                    HStack {
                        Slider(
                            value: $assistant.temperature,
                            in: 0...2,
                            step: 0.1
                        ) {
                            Text("Temperature")
                        }
                        Text("\(assistant.temperature, specifier: "%.1f")")
                    }
                   
                }
                HStack{
                    Text("Model").padding(.leading, 35)
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
                }
                
                HStack(alignment: .top) {
                    Text("Prompt").padding(.leading, 30)
                    TextEditor(text: $assistant.prompt)
                        .frame(height: 100)
                        .font(.title3)
                        .textEditorStyle(.plain)
                        .padding(.top, 2)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                .shadow(radius: 10)
                        }
                }
            }.textFieldStyle(.roundedBorder)
                .padding()
        } label: {
            Text("Edit").font(.title).bold()
        }.padding()
        Button("Save") {
            dismiss()
        }.padding(.bottom).keyboardShortcut(.return,modifiers: [])
    }
    
    /// 获取默认模型的名字
    /// - Returns: 默认模型的名字
    private func getDefaultModelName() -> String {
        var name = "Select Model"
        if let model = assistant.model {
            name = model.name
        }
        return name
    }
    
    
    private func setDefaultModel(model:AIModel){
        assistant.model = model
    }
    
    
}
