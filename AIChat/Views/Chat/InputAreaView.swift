//
//  InputAreaView.swift
//  AIChat
//
//  Created by Lion on 2025/4/30.
//

import SwiftData
import SwiftUI

// MARK: - Input Area View
struct InputAreaView: View {
    @Binding var userInput: String
    let isSending: Bool
    let sendAction: () -> Void

    var body: some View {
        HStack {
            TextEditor(text: $userInput)
                .scrollContentBackground(.hidden)
                .disabled(isSending)
                .frame(height: 50)
                .padding()
                .font(.title)
                .cornerRadius(50)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                )
            Button(action: sendAction) {
                if isSending {
                    ProgressView()
                        .scaleEffect(2)
                        .frame(width: 80)
                } else {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 80))
                }
            }
            .keyboardShortcut(.return, modifiers: .command)
            .disabled(
                userInput.trimmingCharacters(in: .whitespacesAndNewlines)
                    .isEmpty || isSending
            )
            .buttonStyle(.link)
            .padding(.trailing)
        }
        .padding()
        .background()
    }
}
