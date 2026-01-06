//
//  User.swift
//  ScamShield
//
//  Created on 2026-01-06.
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    let email: String
    let createdAt: Date
    var linkedFamily: [String] // 綁定的家人 userIds
    var fcmToken: String?

    init(id: String, email: String, createdAt: Date = Date(), linkedFamily: [String] = [], fcmToken: String? = nil) {
        self.id = id
        self.email = email
        self.createdAt = createdAt
        self.linkedFamily = linkedFamily
        self.fcmToken = fcmToken
    }
}

// Firestore 文件轉換用
extension User {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "email": email,
            "createdAt": createdAt,
            "linkedFamily": linkedFamily
        ]
        if let fcmToken = fcmToken {
            dict["fcmToken"] = fcmToken
        }
        return dict
    }

    static func fromDictionary(id: String, data: [String: Any]) -> User? {
        guard
            let email = data["email"] as? String,
            let createdAt = data["createdAt"] as? Date
        else {
            return nil
        }

        let linkedFamily = data["linkedFamily"] as? [String] ?? []
        let fcmToken = data["fcmToken"] as? String

        return User(
            id: id,
            email: email,
            createdAt: createdAt,
            linkedFamily: linkedFamily,
            fcmToken: fcmToken
        )
    }
}
