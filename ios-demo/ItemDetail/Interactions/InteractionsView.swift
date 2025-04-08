//
//  InteractionsView.swift
//  ios-demo
//
//  Created by Jan Bednar on 06.04.2025.
//

import SwiftUI

struct InteractionsView: View {
    @State private var viewModel: InteractionsViewModel

    init(itemId: String, recommId: String?, userId: String) {
        _viewModel = State(
            initialValue: InteractionsViewModel(itemId: itemId, recommId: recommId, userId: userId)
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("User-Item interactions")
                    .font(.title2)
                ForEach(InteractionsViewModel.BottomSheet.allCases) { bottomSheet in
                    Button {
                        viewModel.selectedBottomSheet = bottomSheet
                    } label: {
                        Text(bottomSheet.title)
                    }
                    .buttonStyle(.borderedProminent)
                }
                if let recommId = viewModel.recommId {
                    Text("Recommendation ID:\n\(recommId)")
                }
                HStack {}.frame(maxWidth: .infinity)
            }
            .padding()
            .alert("Error", isPresented: $viewModel.isAlertShown) {} message: {
                    Text(viewModel.errorAlert ?? "")
            }
            .sheet(item: $viewModel.selectedBottomSheet) { bottomSheet in
                VStack(spacing: 8) {
                    Text("\(bottomSheet.title)")
                        .font(.headline)
                    Spacer()
                    switch bottomSheet {
                    case .bookmark:
                        Button { viewModel.sendBookmark() } label: { Text("Send bookmark") }
                    case .cartAddition:
                        CartAdditionSheetView(action: viewModel.sendCartAddition)
                    case .detailView:
                        DetailViewSheetView(action: viewModel.sendDetailView)
                    case .purchase:
                        PurchaseSheetView(action: viewModel.sendPurchase)
                    case .rating:
                        SliderSheetView(title: "rating", range: -1.0...1.0, step: 1/50, action: viewModel.sendRating)
                    case .viewPortion:
                        SliderSheetView(title: "view portion", range: 0.0...1.0, step: 1/50, action: viewModel.sendViewPortion)
                    }
                    Spacer()
                }
                .textFieldStyle(.roundedBorder)
                .padding()
                .presentationDetents([.height(250)])
            }
        }
    }
}

struct CartAdditionSheetView: View {
    @State private var amount: Double?
    @State private var price: Double?
    let action: (_ amount: Double?, _ price: Double?) -> Void

    var body: some View {
        TextField("Amount", value: $amount, format: .number)
        TextField("Price", value: $price, format: .number)
        Button { action(amount, price) } label: { Text("Send cart addition") }
    }
}

struct DetailViewSheetView: View {
    @State private var duration: Int?
    let action: (_ duration: Int?) -> Void

    var body: some View {
        TextField("Duration", value: $duration, format: .number)
        Button { action(duration) } label: { Text("Send detail view") }
    }
}

struct PurchaseSheetView: View {
    @State private var amount: Double?
    @State private var price: Double?
    @State private var profit: Double?
    let action: (_ amount: Double?, _ price: Double?, _ profit: Double?) -> Void

    var body: some View {
        TextField("Amount", value: $amount, format: .number)
        TextField("Price", value: $price, format: .number)
        TextField("Profit", value: $profit, format: .number)
        Button { action(amount, price, profit) } label: { Text("Send purchase") }
    }
}

struct SliderSheetView: View {
    let title: String
    let range: ClosedRange<Double>
    let step: Double
    @State private var value: Double = 0
    let action: (Double) -> Void

    var body: some View {
        Text(value.formatted(.number))
        Slider(value: $value, in: range, step: step)
        Button { action(value) } label: { Text("Send \(title)") }
    }
}

#Preview {
    InteractionsView(itemId: "0", recommId: nil, userId: "1")
}
