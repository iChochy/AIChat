//
//  CustomButtonView.swift
//  iChat
//
//  Created by Lion on 2025/5/23.
//

import SwiftUI

struct CustomButtonView: View {
    @Binding var showingPopover:Bool
    let message: ChatMessage    
    var scrollView : () -> Void
    @State var isHover = false
    var body: some View {
        Button {
            showingPopover.toggle()
            scrollView()
        } label: {
            HStack{
                Text(message.content)
                    .font(.headline)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .padding(message.role == .assistant ?  .leading: .trailing)
                Spacer()
            }.frame(maxWidth: 200)
        }.padding(3)
            .padding(.horizontal,5)
            .buttonStyle(.plain)
            .background(
                RoundedRectangle(cornerRadius: 3)
                    .fill(
                        isHover ? Color.accentColor.opacity(0.5) : Color.clear
                    )
            )
            .foregroundColor(isHover ? .white : .primary)
            .onHover { hover in
                isHover = hover
            }
    }

}
