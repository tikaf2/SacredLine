//
//  SacredLineApp.swift
//  SacredLine
//
//  Created by Mentari Tika on 15/09/26.
//

import SwiftUI

@main
struct SacredLineApp: App {
    // Menyimpan status onboarding di UserDefaults
    @AppStorage("isOnboardingCompleted") var isOnboardingCompleted: Bool = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isOnboardingCompleted {
                    MainContainerView()
                } else {
                    OnboardingView(isOnboardingCompleted: $isOnboardingCompleted)
                }
            }
        }
    }
}
