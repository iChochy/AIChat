//
//  LanguageEnum.swift
//  AIChat
//
//  Created by Lion on 2025/6/1.
//

import Foundation
import SwiftUICore

enum LanguageEnum: String, CaseIterable, Identifiable, Hashable {
    case auto = "Auto"
    case chinese = "中文"
    case english = "English"
    // Conformance to Identifiable protocol for ForEach
    var id: Self { self }

    var content: String {
        switch self {
        case .chinese:
            return "Answer in Chinese"
        case .english:
            return "Answers in English"
        default:
            return ""
        }
    }
    

}
