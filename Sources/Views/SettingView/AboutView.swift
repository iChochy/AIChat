//
//  ProviderView.swift
//  iChat
//
//  Created by Lion on 2025/5/19.
//

import SwiftUI

struct AboutView: View {
    let title = "About"
    let icon = "info.circle"

    // 从 Bundle 获取基本信息

    let appName =
        Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
    let appVersion =
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        ?? "1.0"
    let appBuild =
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        ?? "1"
    let copyright =
        Bundle.main.infoDictionary?["NSHumanReadableCopyright"] as? String
        ?? "© iChochy"

    // 额外信息（可以根据需要修改）
    private let developer = "iChochy"
    private let blog = "https://ichochy.com"
    private let website = "https://ai.ichochy.com"
    private let supportEmail = "it.osx@icloud.com"

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 应用图标
                Image(
                    nsImage: NSImage(named: NSImage.applicationIconName)
                        ?? NSImage()
                )
                .frame(width: 128, height: 128)
                .shadow(radius: 5)

                // 应用基本信息
                Text(appName)
                    .font(.title)
                    .fontWeight(.bold)

                Text("Bate Version \(appVersion) (Build \(appBuild))")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                // 分割线
                Divider()

                // 详细信息
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Developer:")
                            .fontWeight(.semibold)
                        Text(developer)
                    }

                    HStack {
                        Text("Blog:")
                            .fontWeight(.semibold)
                        Button(action: {
                            if let url = URL(string: website) {
                                NSWorkspace.shared.open(url)
                            }
                        }) {
                            Text(blog)
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }

                    HStack {
                        Text("Support:")
                            .fontWeight(.semibold)
                        Button(action: {
                            if let url = URL(string: "mailto:\(supportEmail)") {
                                NSWorkspace.shared.open(url)
                            }
                        }) {
                            Text(supportEmail)
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    HStack {
                        Text("Released:")
                            .fontWeight(.semibold)
                        Text(getBuildDate(), style: .date)
                    }

                }
                .font(.body)

                Divider()

                // 操作按钮
                HStack(spacing: 20) {
                    Button("Visit Website") {
                        if let url = URL(string: website) {
                            NSWorkspace.shared.open(url)
                        }
                    }
                    .keyboardShortcut(.defaultAction)
                }
                Spacer()
                // 版权信息
                Text(copyright)
                    .font(.footnote)
                    .foregroundColor(.gray)

            }.padding()
            .navigationTitle("About")
        }
    }

    private func getBuildDate() -> Date {
        if let executablePath = Bundle.main.executablePath {
            do {
                let attributes = try FileManager.default.attributesOfItem(
                    atPath: executablePath
                )
                if let creationDate = attributes[.modificationDate] as? Date {
                    return creationDate
                }
            } catch {
                print("获取可执行文件时间失败: \(error)")
            }
        }
        return Date()
    }
}
