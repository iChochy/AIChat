//
//  LanguageEnum.swift
//  AIChat
//
//  Created by Lion on 2025/6/1.
//

import Foundation
import SwiftUI

enum AppearanceEnum: String, CaseIterable, Identifiable, Hashable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    // Conformance to Identifiable protocol for ForEach
    var id: Self { self }

    var theme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return .none
        }
    }
    
    var name: NSAppearance? {
        switch self {
        case .light:
            return NSAppearance.init(named: .aqua)
        case .dark:
            return NSAppearance.init(named: .darkAqua)
        case .system:
            return .none
        }
    }

}
