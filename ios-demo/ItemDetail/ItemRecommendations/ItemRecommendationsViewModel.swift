//
//  ItemRecommendationsViewModel.swift
//  ios-demo
//
//  Created by Jan Bednar on 06.04.2025.
//

import Foundation
import RecombeeClient

@MainActor
@Observable
final class ItemRecommendationsViewModel {
    private(set) var items: [Item] = []
    private(set) var isLoading = false
    private(set) var recommId: String?
    private(set) var errorAlert: String?
    var isAlertShown: Bool {
        get { errorAlert != nil }
        set { errorAlert = nil }
    }

    private let client = Recombee.client
    private let itemId: String
    let userId: String

    init(itemId: String, userId: String) {
        self.itemId = itemId
        self.userId = userId
    }

    func loadItems() async {
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            let response = try await client
                .send(
                    RecommendItemsToItem(
                        itemId: itemId,
                        targetUserId: userId,
                        count: 10,
                        scenario: "related-assets",
                        returnProperties: true
                    )
                )
            recommId = response.recommId
            items = try response.recomms.map(Item.init)
        } catch {
            print("HomeViewModel: Failed to load items: \(error)")
            errorAlert = error.localizedDescription
        }
    }
}
