//
//  GeneralView.swift
//  iChat
//
//  Created by Lion on 2025/5/19.
//

import SwiftUI

struct GeneralView: View {
    let title = "General"
    let icon = "gear"
    @AppStorage("fontSize") var fontSize = 15.0
    @AppStorage("nicknames") var nickname = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
    @AppStorage("language") var language = LanguageEnum.auto
    @AppStorage("appearance") var appearance = AppearanceEnum.system
    @AppStorage("isInserted") var isInserted = true

    var body: some View {
        ScrollView {
            Form {
                GroupBox {
                    Section(
                        "Open menu bar icon?"
                    ) {
                        Picker("MenuBar", selection: $isInserted) {
                            Text("Open").tag(true)
                            Text("Close").tag(false)
                        }.pickerStyle(.segmented).padding()
                    }
                    
                    Section(
                        "Select app appearance?"
                    ) {
                        Picker("Appearance", selection: $appearance) {
                            ForEach(AppearanceEnum.allCases) { item in
                                Text(item.rawValue)
                            }
                        }.pickerStyle(.segmented).padding()
                    }
//                    Section(
//                        "Set the font size?"
//                    ) {
//                        HStack {
//                            Slider(value: $fontSize, in: 10...30, step: 1) {
//                                Text("Font size")
//                            } minimumValueLabel: {
//                                Text("10")
//                            } maximumValueLabel: {
//                                Text("30")
//                            }
//                            Text("\(Int(fontSize))").frame(width: 30)
//                            
//                        }.padding()
//                    }
                } label: {
                    Text("App Settings").font(.title).padding(.bottom)
                }.padding()
                
                GroupBox {
                    Section("What should we call you?") {
                        
                        TextField(
                            "Nickname",
                            text: $nickname,
                            prompt: Text("What should we call you?")
                        ).padding()
                    }
                    
                    Section(
                        "Select the language for AI response?"
                    ) {
                        
                        Picker("Language", selection: $language) {
                            ForEach(LanguageEnum.allCases) { item in
                                Text(item.rawValue)
                            }
                        }.pickerStyle(.segmented).padding()
                    }
                    
                } label: {
                    Text("AI Settings").font(.title).padding(.bottom)
                }.padding()
                
               
                
                
            }.padding()
                .textFieldStyle(.roundedBorder)
                .navigationTitle("General")
        }
    }
}
