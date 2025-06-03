//
//  AIChatApp.swift
//  AIChat
//
//  Created by Lion on 2025/4/1.
//

import SwiftData
import SwiftUI

@main
struct AIChatApp: App {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("appearance") var appearance = AppearanceEnum.system
    @AppStorage("isInserted") var isInserted = true
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ChatSession.self,
            AIProvider.self,
            MarkdownCategory.self,
            MarkdownItem.self,
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup(id: "Chat") {
            //            MarkdownParserView()
            AIContentView()
                .onAppear(perform: {
                    NSApp.appearance = appearance.name
                }).onChange(
                    of: appearance,
                    {
                        NSApp.appearance = appearance.name
                    }
                )
                .frame(minWidth: 800, minHeight: 500)  // 可以设置最小尺寸
        }.modelContainer(sharedModelContainer)

        
        MenuBarExtra(isInserted: $isInserted) {
            MenuBarExtraView()
        } label: {
            Text("AI")
        }

        Window("Settings", id: "Settings") {  // 给窗口一个标题和 ID
            SettingsView()
                .onAppear(perform: {
                    NSApp.appearance = appearance.name
                }).onChange(
                    of: appearance,
                    {
                        NSApp.appearance = appearance.name
                    }
                )
                .frame(minWidth: 600, minHeight: 400)  // 可以设置最小尺寸
        }.modelContainer(sharedModelContainer)

        // 定义你的置顶窗口场景
        Window("Pinned Utility Panel", id: "pinned-window") {  // 给窗口一个标题和 ID
            WindowView()  // 这是置顶窗口的内容视图
                .frame(minWidth: 800, minHeight: 500)  // 可以设置最小尺寸
        }
        // .windowResizability(.contentSize) // 可以让窗口大小根据内容调整，不可手动调整大小

    }

}
