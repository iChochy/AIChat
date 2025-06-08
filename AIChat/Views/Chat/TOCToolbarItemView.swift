//
//  TOCToolbarItemView.swift
//  AIChat
//
//  Created by Lion on 2025/6/8.
//

import SwiftUI

struct TOCToolbarItemView: View {
    @State private var showingPopover = false
    let messages: [ChatMessage]
    let proxy: ScrollViewProxy

    var body: some View {
        Button {
            showingPopover.toggle()
        } label: {
            Label("TOC", systemImage: "list.bullet")
        }
        .popover(
            isPresented: $showingPopover,
            arrowEdge: .bottom
        ) {
            GroupBox {
                ForEach(messages) { item in
                    CustomButtonView(
                        showingPopover: $showingPopover,
                        message: item
                    ) {
                        scrollToMessage(message: item)
                    }
                }
            } label: {
                Text("TOC").font(.title3)
            }.padding(.top)
        }
    }
    
    func scrollToMessage(message:ChatMessage){
        proxy.scrollTo(message, anchor: .bottom)
    }

}
