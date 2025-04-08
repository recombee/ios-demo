//
//  ItemView.swift
//  ios-demo
//
//  Created by Jan Bednar on 04.04.2025.
//

import SwiftUI

struct ItemView: View {
    let item: Item
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            AsyncImage(url: item.images.first.flatMap(URL.init)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
            } placeholder: {
                ProgressView()
                    .frame(width: 80)
                    .frame(maxHeight: .infinity)
                    .background(.background.secondary)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.headline)
                Text(item.description)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 120)
    }
}

#Preview {
    ItemView(item: .mock())
}
