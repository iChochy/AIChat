//
//  ProviderView.swift
//  AIChat
//
//  Created by Lion on 2025/5/19.
//

import SwiftData
import SwiftUI

struct ModelEditorView: View {
    @Environment(\.modelContext) private var context
    @Bindable var provider: AIProvider
    @State var isPresentedAdd = false
    @State var isPresentedEdit = false

    var body: some View {
        Section {
            ForEach(provider.models) { item in
                Divider()
                HStack {
                    Text(item.name).tag(item)
                    Spacer()
                    Button {
                        delete(model: item)
                    } label: {
                        Image(systemName: "minus")
                    }.buttonBorderShape(.circle)
                }
            }
        } header: {
            HStack {
                Text("Models").font(.title2)
                Button {
                    openModelFetchView()
                } label: {
                    Label("fetch", systemImage: "square.and.arrow.down")
                }.disabled(provider.APIKey.isEmpty || provider.APIURL.isEmpty)
                    .buttonStyle(.borderedProminent)
                    .sheet(isPresented: $isPresentedEdit){
                        ModelFetchView(provider: provider)
                    }
                Spacer()
                Button {
                    openModelAddView()
                } label: {
                    Image(systemName: "plus")
                }.buttonBorderShape(.circle)
                    .background(Color.accentColor)
                    .clipShape(.circle)
                    .sheet(
                        isPresented: $isPresentedAdd,
                    ) {
                        ModelAddView(provider: provider)
                    }
            }
        }
    }



    private func delete(model: AIModel) {
        context.delete(model)
        try? context.save()
    }
    private func openModelAddView() {
        isPresentedAdd.toggle()
    }
    private func openModelFetchView() {
        isPresentedEdit.toggle()
    }
}
