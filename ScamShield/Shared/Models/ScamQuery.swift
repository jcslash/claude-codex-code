//
//  ScamQuery.swift
//  ScamShield
//
//  Created on 2026-01-06.
//

import Foundation

struct ScamQuery: Codable, Identifiable {
    let id: String
    let userId: String
    let content: String // 分享的訊息內容
    let result: ScamResult
    let createdAt: Date

    init(id: String = UUID().uuidString, userId: String, content: String, result: ScamResult, createdAt: Date = Date()) {
        self.id = id
        self.userId = userId
        self.content = content
        self.result = result
        self.createdAt = createdAt
    }

    // 訊息摘要（前 50 字）
    var summary: String {
        let maxLength = 50
        if content.count <= maxLength {
            return content
        }
        let index = content.index(content.startIndex, offsetBy: maxLength)
        return String(content[..<index]) + "..."
    }

    // 格式化時間顯示
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.locale = Locale(identifier: "zh_TW")
        return formatter.string(from: createdAt)
    }
}

// Firestore 文件轉換用
extension ScamQuery {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "userId": userId,
            "content": content,
            "createdAt": createdAt,
            "result": [
                "id": result.id,
                "isScam": result.isScam,
                "confidence": result.confidence,
                "reason": result.reason,
                "scamType": result.scamType,
                "riskLevel": result.riskLevel.rawValue
            ]
        ]
        return dict
    }

    static func fromDictionary(id: String, data: [String: Any]) -> ScamQuery? {
        guard
            let userId = data["userId"] as? String,
            let content = data["content"] as? String,
            let createdAt = (data["createdAt"] as? Date),
            let resultDict = data["result"] as? [String: Any],
            let isScam = resultDict["isScam"] as? Bool,
            let confidence = resultDict["confidence"] as? Int,
            let reason = resultDict["reason"] as? String,
            let scamType = resultDict["scamType"] as? String
        else {
            return nil
        }

        let result = ScamResult(
            id: resultDict["id"] as? String ?? UUID().uuidString,
            isScam: isScam,
            confidence: confidence,
            reason: reason,
            scamType: scamType
        )

        return ScamQuery(
            id: id,
            userId: userId,
            content: content,
            result: result,
            createdAt: createdAt
        )
    }
}
