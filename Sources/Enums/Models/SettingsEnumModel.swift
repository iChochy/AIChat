//
//  SettingsModel.swift
//  iChat
//
//  Created by Lion on 2025/5/19.
//

import Foundation
import SwiftUI

class SettingsEnumModel {
    var title: String = ""
    var icon: String = ""
    var view: AnyView = AnyView(EmptyView())
    
    init(title: String, icon: String, view: some View) {
        self.title = title
        self.icon = icon
        self.view = AnyView(view)
    }
    
    
    static func getGeneral() -> SettingsEnumModel{
        let view = GeneralView();
        return SettingsEnumModel(title: view.title, icon: view.icon, view: view)
    }
    
    static func getProvider() -> SettingsEnumModel{
        let view = ProviderView();
        return SettingsEnumModel(title: view.title, icon: view.icon, view: view)
    }
    
    static func getAbout() -> SettingsEnumModel{
        let view = AboutView();
        return SettingsEnumModel(title: view.title, icon: view.icon, view: view)
    }
    
    
}
