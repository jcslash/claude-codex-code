//
//  MainViewModel.swift
//  ScamShield
//
//  Created on 2026-01-06.
//

import Foundation
import SwiftUI

@MainActor
class MainViewModel: ObservableObject {
    @Published var queries: [ScamQuery] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let userId = "demo_user" // Phase 1: 使用假的 userId，Phase 2 會改用 Firebase Auth

    init() {
        loadQueries()
    }

    func loadQueries() {
        // Phase 1: 從 UserDefaults 載入
        // Phase 2: 從 Firestore 載入
        if let data = UserDefaults.shared.data(forKey: "scam_queries"),
           let decoded = try? JSONDecoder().decode([ScamQuery].self, from: data) {
            self.queries = decoded.sorted { $0.createdAt > $1.createdAt }
        }
    }

    func saveQuery(_ query: ScamQuery) {
        queries.insert(query, at: 0)

        // Phase 1: 儲存到 UserDefaults
        // Phase 2: 儲存到 Firestore
        if let encoded = try? JSONEncoder().encode(queries) {
            UserDefaults.shared.set(encoded, forKey: "scam_queries")
        }
    }

    func deleteQuery(_ query: ScamQuery) {
        queries.removeAll { $0.id == query.id }

        if let encoded = try? JSONEncoder().encode(queries) {
            UserDefaults.shared.set(encoded, forKey: "scam_queries")
        }
    }
}

// UserDefaults extension for App Groups (Phase 1 使用標準的，Phase 2 會改用 App Groups)
extension UserDefaults {
    static let shared = UserDefaults.standard
    // Phase 2: static let shared = UserDefaults(suiteName: "group.com.scamshield.app")!
}
