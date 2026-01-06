//
//  ScamResult.swift
//  ScamShield
//
//  Created on 2026-01-06.
//

import Foundation

enum RiskLevel: String, Codable {
    case high
    case medium
    case low

    var displayName: String {
        switch self {
        case .high: return "高風險詐騙"
        case .medium: return "中度可疑"
        case .low: return "安全"
        }
    }

    var color: String {
        switch self {
        case .high: return "#DC2626"
        case .medium: return "#F59E0B"
        case .low: return "#10B981"
        }
    }

    var emoji: String {
        switch self {
        case .high: return "🔴"
        case .medium: return "🟡"
        case .low: return "🟢"
        }
    }
}

struct ScamResult: Codable, Identifiable {
    let id: String
    let isScam: Bool
    let confidence: Int // 0-100
    let reason: String
    let scamType: String
    let riskLevel: RiskLevel

    init(id: String = UUID().uuidString, isScam: Bool, confidence: Int, reason: String, scamType: String) {
        self.id = id
        self.isScam = isScam
        self.confidence = confidence
        self.reason = reason
        self.scamType = scamType

        // 根據 confidence 決定風險等級
        if confidence >= 80 {
            self.riskLevel = .high
        } else if confidence >= 50 {
            self.riskLevel = .medium
        } else {
            self.riskLevel = .low
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        isScam = try container.decode(Bool.self, forKey: .isScam)
        confidence = try container.decode(Int.self, forKey: .confidence)
        reason = try container.decode(String.self, forKey: .reason)
        scamType = try container.decode(String.self, forKey: .scamType)

        if let level = try? container.decode(RiskLevel.self, forKey: .riskLevel) {
            riskLevel = level
        } else {
            // 根據 confidence 決定風險等級
            if confidence >= 80 {
                riskLevel = .high
            } else if confidence >= 50 {
                riskLevel = .medium
            } else {
                riskLevel = .low
            }
        }
    }
}

// Gemini API 回應格式
struct GeminiResponse: Codable {
    let is_scam: Bool
    let confidence: Int
    let reason: String
    let scam_type: String

    func toScamResult() -> ScamResult {
        return ScamResult(
            isScam: is_scam,
            confidence: confidence,
            reason: reason,
            scamType: scam_type
        )
    }
}
