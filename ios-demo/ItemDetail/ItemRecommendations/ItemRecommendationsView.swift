//
//  ItemRecommendationsView.swift
//  ios-demo
//
//  Created by Jan Bednar on 06.04.2025.
//

import SwiftUI

struct ItemRecommendationsView: View {
    @State private var viewModel: ItemRecommendationsViewModel

    init(itemId: String, userId: String) {
        _viewModel = State(wrappedValue: .init(itemId: itemId, userId: userId))
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.items) { item in
                    NavigationLink(
                        value: ItemDestination(
                            item: item,
                            recommId: viewModel.recommId
                        )
                    ) {
                        ItemView(item: item)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .refreshable {
            await viewModel.loadItems()
        }
        .task {
            await viewModel.loadItems()
        }
        .alert("Error", isPresented: $viewModel.isAlertShown) {
            Text(viewModel.errorAlert ?? "")
        }
    }
}

#Preview {
    ItemRecommendationsView(itemId: "0", userId: "1")
}
