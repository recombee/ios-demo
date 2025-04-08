//
//  ios_demoApp.swift
//  ios-demo
//
//  Created by Jan Bednar on 03.04.2025.
//

import SwiftUI

@main
struct ios_demoApp: App {
    @AppStorage("isOnboardingComplete") private var isOnboardingComplete = false
    @AppStorage("userId") private var userId: String = UUID().uuidString

    var body: some Scene {
        WindowGroup {
            if isOnboardingComplete {
                HomeView(
                    userId: userId,
                    onResetUserId: {
                        userId = UUID().uuidString
                    },
                    onResetOnboarding: {
                        isOnboardingComplete = false
                    }
                )
                .id(userId)
            } else {
                OnboardingView() {
                    withAnimation {
                        isOnboardingComplete = true
                    }
                }
            }
        }
    }
}
