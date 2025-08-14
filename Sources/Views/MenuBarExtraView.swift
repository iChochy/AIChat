//
//  MenuBarExtraView.swift
//  iChat
//
//  Created by Lion on 2025/6/5.
//

import SwiftUI

struct MenuBarExtraView: View {
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        Button("Chat") {
            openChatWindow()
        }.keyboardShortcut("N")
        Button("Setting..") {
            NSApp.activate(ignoringOtherApps: true)
            openWindow(id: "Settings")
        }.keyboardShortcut(",")
        Divider()
        Button("About"){
            NSApp.orderFrontStandardAboutPanel(nil)
        }
        Button("Quit") {
            NSApp.terminate(nil)
        }.keyboardShortcut("Q")
    }

    func openChatWindow() {
        let existingWindow = NSApp.windows.first { window in
            window.identifier?.rawValue.hasPrefix("Chat") == true
        }
        if let window = existingWindow {
            if window.isMiniaturized {
                window.deminiaturize(nil)
            } else {
                window.makeKeyAndOrderFront(nil)
            }
        } else {
            NSApp.activate(ignoringOtherApps: true)
            openWindow(id: "Chat")
        }
    }

}

#Preview {
    MenuBarExtraView()
}
