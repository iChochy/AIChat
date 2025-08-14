import SwiftData
//
//  SettingsView.swift
//  iChat
//
//  Created by Lion on 2025/4/28.
//
import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State var selectView: SettingsEnum = SettingsEnum.general

    var body: some View {
        NavigationSplitView {
            List(selection: $selectView) {
                Section {
                    Divider()
                    ForEach(SettingsEnum.allCases) { item in
                        Label(
                            item.data.title,
                            systemImage: item.data.icon
                        ).tag(item)
                    }
                } header: {
                    Text("Settings").font(.largeTitle)
                }
            }
        } detail: {
            selectView.data.view
        }
    }
}
