//
//  HomeViewModel.swift
//  ios-demo
//
//  Created by Jan Bednar on 04.04.2025.
//

import Foundation
import RecombeeClient

@MainActor
@Observable
final class HomeViewModel {
    private(set) var items: [Item] = []
    private(set) var isLoading = false
    private(set) var recommId: String?
    private(set) var errorAlert: String?
    var isAlertShown: Bool {
        get { errorAlert != nil }
        set { errorAlert = nil }
    }

    private let client = Recombee.client
    let userId: String

    init(userId: String) {
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
                    RecommendItemsToUser(
                        userId: userId,
                        count: 10,
                        scenario: "homepage-top-for-you",
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
