//
//  ItemView.swift
//  ios-demo
//
//  Created by Jan Bednar on 06.04.2025.
//

import SwiftUI

struct ItemDetailView: View {
    let item: Item
    let recommId: String?
    let userId: String
    @State private var selection = Selection.interactions

    enum Selection: Hashable {
        case interactions
        case recommendations
    }

    var body: some View {
        TabView(selection: $selection) {
            InteractionsView(itemId: item.id, recommId: recommId, userId: userId)
                .tag(Selection.interactions)
            ItemRecommendationsView(itemId: item.id, userId: userId)
                .tag(Selection.recommendations)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .navigationTitle("Item ID: \(item.id)")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .top, spacing: 0) {
            Picker(selection: $selection) {
                Text("Interactions")
                    .tag(Selection.interactions)
                Text("Item to item")
                    .tag(Selection.recommendations)
            } label: {
                Text("Select tab")
            }
            .pickerStyle(.segmented)
            .padding()
            .overlay(alignment: .bottom) {
                Rectangle().fill(.background.secondary).frame(height: 2)
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .background(
            Rectangle()
                .fill(.background)
                .ignoresSafeArea(.all, edges: .bottom)
        )
    }
}

#Preview {
    NavigationView {
        ItemDetailView(item: .mock(), recommId: nil, userId: "1")
    }
}
