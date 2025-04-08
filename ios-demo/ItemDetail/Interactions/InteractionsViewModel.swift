//
//  InteractionsViewModel.swift
//  ios-demo
//
//  Created by Jan Bednar on 06.04.2025.
//

import Foundation
import RecombeeClient

@Observable
@MainActor
final class InteractionsViewModel {
    enum Notification {
        case bookmarkSuccess
        case cartAdditionSuccess
        case detailViewSuccess
        case purchaseSuccess
        case ratingSuccess
        case viewPortionSuccess
    }

    enum BottomSheet: String, CaseIterable, Identifiable {
        case bookmark = "Bookmark"
        case cartAddition = "Cart addition"
        case detailView = "Detail view"
        case purchase = "Purchase"
        case rating = "Rating"
        case viewPortion = "View portion"

        var id: String { rawValue }

        var title: String { rawValue }
    }

    private let itemId: String
    let recommId: String?
    private let userId: String
    var selectedBottomSheet: BottomSheet?
    private(set) var errorAlert: String?
    var isAlertShown: Bool {
        get { errorAlert != nil }
        set { errorAlert = nil }
    }

    private let client = Recombee.client

    init(itemId: String, recommId: String?, userId: String) {
        self.itemId = itemId
        self.recommId = recommId
        self.userId = userId
    }

    func sendBookmark() {
        sendInteraction(
            request: AddBookmark(
                userId: userId,
                itemId: itemId,
                timestamp: Date(),
                recommId: recommId
            ),
            successNotification: .bookmarkSuccess
        )
    }

    func sendCartAddition(amount: Double?, price: Double?) {
        sendInteraction(
            request: AddCartAddition(
                userId: userId,
                itemId: itemId,
                timestamp: Date(),
                amount: amount,
                price: price,
                recommId: recommId
            ),
            successNotification: .cartAdditionSuccess
        )
    }

    func sendDetailView(duration: Int?) {
        sendInteraction(
            request: AddDetailView(
                userId: userId,
                itemId: itemId,
                timestamp: Date(),
                duration: duration,
                recommId: recommId
            ),
            successNotification: .detailViewSuccess
        )
    }

    func sendPurchase(
        amount: Double?,
        price: Double?,
        profit: Double?
    ) {
        sendInteraction(
            request: AddPurchase(
                userId: userId,
                itemId: itemId,
                timestamp: Date(),
                amount: amount,
                price: price,
                profit: profit,
                recommId: recommId
            ),
            successNotification: .purchaseSuccess
        )
    }

    func sendRating(rating: Double) {
        sendInteraction(
            request: AddRating(
                userId: userId,
                itemId: itemId,
                rating: rating,

                timestamp: Date(),
                recommId: recommId
            ),
            successNotification: .ratingSuccess
        )
    }

    func sendViewPortion(portion: Double) {
        sendInteraction(
            request: SetViewPortion(
                userId: userId,
                itemId: itemId,
                portion: portion,
                timestamp: Date(),
                recommId: recommId
            ),
            successNotification: .viewPortionSuccess
        )
    }

    private func sendInteraction<T: Request>(request: T, successNotification: Notification) {
        Task {
            do {
                let response = try await client.send(request)
                print("InteractionsViewModel - sendInteraction: \(response)")
            } catch {
                print("InteractionsViewModel - sendInteraction error: \(error)")
                errorAlert = error.localizedDescription
            }
            selectedBottomSheet = nil
        }
    }
}
