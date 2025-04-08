//
//  OnboardingView.swift
//  ios-demo
//
//  Created by Jan Bednar on 03.04.2025.
//

import SwiftUI

struct OnboardingView: View {
    let onOnboardingComplete: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text("R")
                    .foregroundStyle(Color.accentColor)
                    .font(.system(size: 72))

                VStack {
                    Text("Welcome to the")
                        .font(.caption)
                    Text("Recombee iOS Demo")
                        .font(.title)
                }
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(
                        [
                            "This application showcases the integration of Recombee's recommendation API within an iOS application, utilizing a dataset comprised of movies.",
                            "The home screen shows the \"Items to User\" scenario (Top Picks for You).",
                            "By tapping on a movie, you can either see \"Items to Item\" recommendations (Related Movies) or send interactions (e.g. rating or how much of a movie has been watched).",
                            "After sending interactions, you can pull to refresh any movie list. The recommended movies are updated to reflect this new data."
                        ]
                        , id: \.self
                    ) { text in
                        Text(text)
                    }
                }
            }
            .padding()
        }
        .defaultScrollAnchor(.center, for: .alignment)
        .scrollBounceBehavior(.basedOnSize)
        .safeAreaInset(edge: .bottom) {
            Button {
                onOnboardingComplete()
            } label: {
                Text("Let's go!")
                    .padding(8)
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom)
        }
    }
}

#Preview {
    OnboardingView() {}
}
