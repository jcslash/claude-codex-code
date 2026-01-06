//
//  ContentView.swift
//  ScamShield
//
//  Created on 2026-01-06.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HistoryView()
                .tabItem {
                    Label("歷史紀錄", systemImage: "list.bullet")
                }
                .tag(0)

            SettingsView()
                .tabItem {
                    Label("設定", systemImage: "gearshape")
                }
                .tag(1)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(MainViewModel())
}
