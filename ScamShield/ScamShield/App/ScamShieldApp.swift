//
//  ScamShieldApp.swift
//  ScamShield
//
//  Created on 2026-01-06.
//

import SwiftUI

@main
struct ScamShieldApp: App {
    @StateObject private var viewModel = MainViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
