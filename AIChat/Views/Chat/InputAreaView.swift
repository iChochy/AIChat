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
    @State private var textHeight: CGFloat = 0
    let isSending: Bool
    let sendAction: () -> Void

    var body: some View {
        HStack(alignment: .bottom) {
            TextEditor(text: $userInput)
                .scrollContentBackground(.hidden)
                .disabled(isSending)
                .frame(height: min(200, max(25, textHeight)))
                .background(
                    Text(userInput.isEmpty ? "" : userInput)
                        .fixedSize(horizontal: false, vertical: true)
                        .hidden()
                        .background(
                            GeometryReader { geometry in
                                Color.clear.onAppear {
                                    textHeight = geometry.size.height
                                }
                                .onChange(
                                    of: userInput,
                                    {
                                        textHeight = geometry.size.height
                                    }
                                )
                            }
                        )
                        .allowsHitTesting(false)
                )
                .padding()
                .font(.title)
                .scrollIndicators(.hidden)
            Button(action: sendAction) {
                    if isSending {
                        ZStack{
                            ProgressView()
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 50)).hidden()
                        }
                    } else {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 50))
                    }
            }
            .keyboardShortcut(.return, modifiers: .command)
            .disabled(
                userInput.trimmingCharacters(in: .whitespacesAndNewlines)
                    .isEmpty || isSending
            )
            .buttonStyle(.link)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.gray.opacity(0.8), lineWidth: 2)
        )
        .background(.quaternary)
        .background()
        .cornerRadius(30)
        .shadow(radius: 10)
        .padding(.bottom)
        .padding(.horizontal,50)
    }
}
