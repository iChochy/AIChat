//
//  CustomMessageView.swift
//  AIChat
//
//  Created by Lion on 2025/5/23.
//

import SwiftUI

struct CustomMessageView: View {
    @Binding var message: String
    var body: some View {
        if !message.isEmpty {
            HStack {
                Text(message)
                    .bold()
                    .foregroundStyle(.red)
                Button {
                    withAnimation {
                        message = ""
                    }
                } label: {
                    Image(systemName: "xmark.circle")
                        .foregroundStyle(.gray)
                }.buttonStyle(.accessoryBar)
            }
            .padding()
            .padding(.horizontal)
            .background(.black.opacity(0.8))
            .border(.black, width: 2)
            .cornerRadius(30)
            .shadow(radius: 10)
            .padding()
            .shadow(radius: 10)
            .animation(.default, value: message)
        }
    }
}
