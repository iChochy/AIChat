//
//  ListView.swift
//  AIChat
//
//  Created by Lion on 2025/6/10.
//

import SwiftUI

// 假设你已经定义了 MenuItem 和 menuData (如之前的示例)

struct AnotherItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let content: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: AnotherItem, rhs: AnotherItem) -> Bool {
        return lhs.id == rhs.id
    }
}

let anotherData: [AnotherItem] = [
    AnotherItem(name: "项目 A", content: "项目 A 的内容"),
    AnotherItem(name: "项目 B", content: "项目 B 的内容"),
    AnotherItem(name: "项目 C", content: "项目 C 的内容")
]


struct MenuItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let children: [MenuItem]?
    let icon: String?
    let content: String?

    init(name: String, children: [MenuItem]? = nil, icon: String? = nil, content: String? = nil) {
        self.name = name
        self.children = children
        self.icon = icon
        self.content = content
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
        return lhs.id == rhs.id
    }
}

let menuData: [MenuItem] = [
    MenuItem(name: "首页", icon: "house", content: "欢迎来到首页"),
    MenuItem(name: "文档", children: [
        MenuItem(name: "SwiftUI", content: "SwiftUI 文档"),
        MenuItem(name: "Swift", content: "Swift 语言文档")
    ], icon: "doc"),
    MenuItem(name: "设置", children: [
        MenuItem(name: "通用", content: "通用设置"),
        MenuItem(name: "网络", content: "网络设置")
    ], icon: "gear"),
    MenuItem(name: "关于", icon: "info.circle", content: "关于此应用")
]

struct ListView: View {
    @State private var selectedMenuItem: MenuItem? = nil
    @State private var selectedAnotherItem: AnotherItem? = nil

    var body: some View {
        NavigationSplitView {
            // Sidebar - 第一个 List（树形菜单）
            List(menuData, children: \.children, selection: $selectedMenuItem) { item in
                Label(item.name, systemImage: item.icon ?? "folder").tag(item)
            }
            .navigationTitle("菜单")

        } content: {
            // Content - 第二个 List
            List(anotherData, selection: $selectedAnotherItem) { item in
                Text(item.name).tag(item)
            }
            .navigationTitle("其他项目")
        } detail: {
            // Detail - 显示选择的项目的内容
            VStack {
                if let selectedMenuItem = selectedMenuItem {
                    Text(selectedMenuItem.content ?? "请选择菜单项")
                        .font(.title)
                        .padding()
                    Text("菜单项：\(selectedMenuItem.name)") // 显示名称
                        .font(.subheadline)

                } else {
                    Text("请选择菜单项")
                        .font(.title)
                        .padding()
                }

                if let selectedAnotherItem = selectedAnotherItem {
                    Text(selectedAnotherItem.content)
                        .font(.title)
                        .padding()
                    Text("另一个项目：\(selectedAnotherItem.name)") // 显示名称
                        .font(.subheadline)
                } else {
                    Text("请选择其他项目")
                        .font(.title)
                        .padding()
                }
            }

            .navigationTitle("详情")
        }
    }
}
