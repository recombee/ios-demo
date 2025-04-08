//
//  HomeView.swift
//  ios-demo
//
//  Created by Jan Bednar on 04.04.2025.
//

import SwiftUI

struct ItemDestination: Hashable {
    let item: Item
    let recommId: String?
}

struct HomeView: View {
    let onResetUserId: () -> Void
    let onResetOnboarding: () -> Void
    @State private var viewModel: HomeViewModel

    init(
        userId: String,
        onResetUserId: @escaping () -> Void,
        onResetOnboarding: @escaping () -> Void
    ) {
        _viewModel = State(wrappedValue: HomeViewModel(userId: userId))
        self.onResetUserId = onResetUserId
        self.onResetOnboarding = onResetOnboarding
    }

    var body: some View {
        NavigationStack{
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
            .alert("Error", isPresented: $viewModel.isAlertShown) {} message: {
                    Text(viewModel.errorAlert ?? "")
            }
            .navigationTitle("Top picks for you")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        VStack(spacing: 16) {
                            VStack {
                                Text("User ID:")
                                Text(viewModel.userId)
                            }
                            Button {
                                onResetUserId()
                            } label: {
                                Text("Reset User ID")
                            }
                            .buttonStyle(.borderedProminent)

                            Button {
                                onResetOnboarding()
                            } label: {
                                Text("View onboarding")
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .navigationTitle("User settings")
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .navigationDestination(for: ItemDestination.self) { destination in
                ItemDetailView(
                    item: destination.item,
                    recommId: destination.recommId,
                    userId: viewModel.userId
                )
            }
        }
    }
}

#Preview {
    HomeView(userId: "0") {} onResetOnboarding: {}
}
