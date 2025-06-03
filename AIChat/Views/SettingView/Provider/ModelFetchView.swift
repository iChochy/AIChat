//
//  ProviderView.swift
//  AIChat
//
//  Created by Lion on 2025/5/19.
//

import SwiftData
import SwiftUI

struct ModelFetchView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss

    @Bindable var provider: AIProvider

    @State var isLoading = false
    @State var searchText = ""

    @State var models: [Model] = []
    @State var messageError = ""

    var body: some View {
        HStack {
            Text("All Models").font(.title2).padding(.leading)
            Spacer()
            CustomSearchView(searchText: $searchText)
        }.padding().padding(.top)

        GroupBox {
            ScrollView {
                Form {
                    if filteredModels.isEmpty {
                        HStack {
                            Spacer()
                            if isLoading {
                                ProgressView()
                                Text("Loading data")
                            } else {
                                Text("No data")
                            }
                            Spacer()
                        }
                        Divider()
                        HStack {
                            Spacer()
                            Text(messageError).font(.footnote).foregroundColor(.red)
                            Spacer()
                        }
                    }
                    ForEach(filteredModels) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Button {
                                addModel(name: item.name)
                            } label: {
                                Image(systemName: "plus")
                            }.buttonBorderShape(.circle)
                        }
                        Divider()
                    }
                }.padding()
            }
        }.padding(.horizontal)
            .onAppear(perform: {
            DispatchQueue.main.async {
                fetchModels()
            }
        })
        Button("Close") {
            dismiss()
        }.padding()
    }
    
    private var filteredModels: [Model] {
        if searchText.isEmpty {
            return showModels(models: models)
        } else {
            return showModels(models: models).filter {
                $0.id.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    

    private func showModels(models: [Model]) -> [Model] {
        let names = Set(provider.models.map { $0.name })
        return models.filter { !names.contains($0.name) }
    }

    private func fetchModels() {
        isLoading = true
        Task {
            do {
                defer {
                    isLoading = false
                }
                models = try await provider.type.data.service.getModels(
                    provider: provider
                )
            } catch {
                messageError = String(describing: error)
            }
        }
    }

    private func addModel(name: String) {
        let model = AIModel(name: name, provider: provider)
        context.insert(model)
        try? context.save()
    }
}
