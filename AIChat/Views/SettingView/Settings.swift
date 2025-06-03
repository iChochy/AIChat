import SwiftData
//
//  SettingsView.swift
//  AIClient
//
//  Created by Lion on 2025/4/28.
//
import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("APIKey") private var GrokAPIKey: String = ""
    @State var selectView: SettingsEnum = SettingsEnum.service

    var body: some View {
        NavigationSplitView {
            List(selection: $selectView){
                Section {
                    Divider()
                    ForEach(SettingsEnum.allCases) { item in
                        Label(
                            item.model.title,
                            systemImage: item.model.icon
                        ).tag(item)
                    }
                }header: {
                    Text("Settings").font(.largeTitle)
                }
            }
        } detail: {
            selectView.model.view
        }
    }
}
