//
//  CustomSearchView.swift
//  iChat
//
//  Created by Lion on 2025/5/23.
//

import SwiftUI

struct CustomSearchView: View {
    @Binding var searchText: String  // 用于绑定搜索文本
    @FocusState var isFocused
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")  // 搜索图标
                .foregroundColor(.gray)
            TextField("Search", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .focused($isFocused)
            if !searchText.isEmpty {
                Button {
                    searchText = ""  // 清空按钮
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .buttonStyle(PlainButtonStyle())  // 确保按钮没有多余的背景
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(Color(NSColor.controlBackgroundColor))  // 给一个背景色以区分
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(isFocused ? Color.accentColor : Color.gray.opacity(0.3), lineWidth: 3)
        ).animation(.easeInOut(duration: 0.2), value: isFocused)
        .frame(maxWidth: 200)
    }
}
