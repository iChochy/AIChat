//
//  InputAreaView.swift
//  iChat
//
//  Created by Lion on 2025/4/30.
//

import SwiftData
import SwiftUI

// MARK: - Input Area View
struct InputAreaView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var chatViewModel: ChatViewModel = ChatViewModel()
    @State private var textHeight: CGFloat = 0
    @Bindable var session: ChatSession

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            TextEditor(text: $chatViewModel.userInput)
                .scrollContentBackground(.hidden)
                .disabled(chatViewModel.isSending)
                .frame(height: min(200, max(22, textHeight)))
                .background(
                    Text(
                        chatViewModel.userInput.isEmpty
                            ? "" : chatViewModel.userInput
                    )
                    .fixedSize(horizontal: false, vertical: true)
                    .hidden()
                    .background(
                        GeometryReader { geometry in
                            Color.clear.onAppear {
                                textHeight = geometry.size.height
                            }
                            .onChange(
                                of: chatViewModel.userInput,
                                {
                                    textHeight = geometry.size.height
                                }
                            )
                        }
                    )
                    .allowsHitTesting(false)
                )
                .padding(.leading,10)
                .padding(.vertical,5)
                .font(.title2)
                .scrollIndicators(.hidden)
            Button {
                sendMessage()
            } label: {
                if chatViewModel.isSending {
                    ZStack {
                        ProgressView().scaleEffect(0.8)
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 30)).hidden()
                    }
                } else {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 30))
                }
            }
            .keyboardShortcut(.return, modifiers: .command)
            .disabled(
                chatViewModel.userInput.trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
                .isEmpty || chatViewModel.isSending
            )
            .buttonStyle(.link)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.gray.opacity(0.8), lineWidth: 2)
        )
        .background(.quaternary)
        .background()
        .cornerRadius(18)
        .padding(.bottom)
        .padding(.horizontal, 50)
        .shadow(radius: 10)
    }

    func sendMessage() {
        chatViewModel.sendMessage(session: session, modelContext: modelContext)
    }
}
