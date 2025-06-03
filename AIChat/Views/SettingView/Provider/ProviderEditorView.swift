//
//  ProviderView.swift
//  AIChat
//
//  Created by Lion on 2025/5/19.
//

import SwiftData
import SwiftUI

struct ProviderEditorView: View {
    @Environment(\.modelContext) private var context

    @Bindable var provider: AIProvider
    @State var isShowAlert = false
    @State var isKeyVisible = true

    var body: some View {
        Section {
            Form {
                ZStack {
                    HStack {
                        if isKeyVisible {
                            SecureField(
                                "APIKey",
                                text: $provider.APIKey,
                                prompt: Text("API Key")
                            )
                        } else {
                            TextField(
                                "APIKey",
                                text: $provider.APIKey,
                                prompt: Text("API Key")
                            )
                        }
                        Button(action: {
                            isKeyVisible.toggle()
                        }) {
                            Image(
                                systemName: isKeyVisible
                                    ? "eye" : "eye.slash.fill"
                            )
                        }.buttonStyle(.borderless)
                    }
                }

                TextField(
                    "APIURL",
                    text: $provider.APIURL,
                    prompt: Text("e.g. https://api.ichochy.com")
                ).textFieldStyle(
                    .roundedBorder
                )
                ModelEditorView(provider: provider)
            }.textFieldStyle(.roundedBorder)
        } header: {
            HStack {
                Spacer()
                Text(provider.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.accentColor)
                Button {
                    showAlert()
                } label: {
                    Image(systemName: "trash")
                }
                .buttonBorderShape(.circle)
                .alert("确认删除吗？", isPresented: $isShowAlert) {
                    Button("Cancel", role: .cancel) { isShowAlert.toggle() }
                    Button("Delete", role: .destructive) {
                        delete(provider: provider)
                    }
                } message: {
                    Text(provider.title)
                }
                Spacer()
            }
        }.padding()
            .padding(.horizontal)
    }

    private func delete(provider: AIProvider) {
        context.delete(provider)
        try? context.save()
    }

    private func showAlert() {
        isShowAlert.toggle()
    }

}
