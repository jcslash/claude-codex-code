//
//  GeminiAPIService.swift
//  ScamShield
//
//  Created on 2026-01-06.
//

import Foundation

enum GeminiAPIError: Error {
    case invalidURL
    case invalidResponse
    case networkError(Error)
    case decodingError(Error)
    case apiError(String)

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "無效的 API 網址"
        case .invalidResponse:
            return "無效的回應格式"
        case .networkError(let error):
            return "網路錯誤：\(error.localizedDescription)"
        case .decodingError(let error):
            return "解析錯誤：\(error.localizedDescription)"
        case .apiError(let message):
            return "API 錯誤：\(message)"
        }
    }
}

class GeminiAPIService {
    static let shared = GeminiAPIService()

    private let apiKey = "AIzaSyB_H4SBMggzumEpaDou-kgtGTggw3Yy0sg"
    private let model = "gemini-2.5-flash-lite"
    private let apiBaseURL = "https://generativelanguage.googleapis.com/v1beta/models"

    private init() {}

    func analyzeMessage(_ message: String) async throws -> ScamResult {
        let prompt = buildPrompt(for: message)
        let url = URL(string: "\(apiBaseURL)/\(model):generateContent?key=\(apiKey)")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ],
            "generationConfig": [
                "temperature": 0.1,
                "maxOutputTokens": 500
            ]
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw GeminiAPIError.invalidResponse
            }

            guard httpResponse.statusCode == 200 else {
                if let errorMessage = String(data: data, encoding: .utf8) {
                    throw GeminiAPIError.apiError(errorMessage)
                }
                throw GeminiAPIError.apiError("HTTP \(httpResponse.statusCode)")
            }

            return try parseGeminiResponse(data)

        } catch let error as GeminiAPIError {
            throw error
        } catch {
            throw GeminiAPIError.networkError(error)
        }
    }

    private func buildPrompt(for message: String) -> String {
        return """
        你是一個專業的詐騙訊息偵測助手，專門分析台灣常見的詐騙手法。

        請分析以下訊息，判斷是否為詐騙。回傳 JSON 格式：

        {
          "is_scam": boolean,
          "confidence": number (0-100),
          "reason": "一句繁體中文解釋，讓60歲長輩也能看懂",
          "scam_type": "投資詐騙" | "假冒銀行" | "假冒政府" | "感情詐騙" | "釣魚連結" | "假冒客服" | "中獎詐騙" | "其他" | "非詐騙"
        }

        常見台灣詐騙特徵：
        - 投資詐騙：保證獲利、加 LINE 私聊、飆股明牌、虛擬貨幣投資群組
        - 假冒銀行：信用卡異常、帳戶凍結、要求點連結驗證
        - 假冒政府：健保/勞保/稅務異常、監管帳戶
        - 感情詐騙：交友軟體認識、快速表白、借錢週轉
        - 釣魚連結：短網址、奇怪網域、模仿知名網站

        請只回傳 JSON，不要有其他文字。

        訊息內容：
        \"\"\"
        \(message)
        \"\"\"
        """
    }

    private func parseGeminiResponse(_ data: Data) throws -> ScamResult {
        // 解析 Gemini API 的回應格式
        struct GeminiAPIResponse: Codable {
            struct Candidate: Codable {
                struct Content: Codable {
                    struct Part: Codable {
                        let text: String
                    }
                    let parts: [Part]
                }
                let content: Content
            }
            let candidates: [Candidate]
        }

        do {
            let apiResponse = try JSONDecoder().decode(GeminiAPIResponse.self, from: data)

            guard let firstCandidate = apiResponse.candidates.first,
                  let firstPart = firstCandidate.content.parts.first else {
                throw GeminiAPIError.invalidResponse
            }

            let responseText = firstPart.text.trimmingCharacters(in: .whitespacesAndNewlines)

            // 移除可能的 markdown code block 標記
            var jsonText = responseText
            if jsonText.hasPrefix("```json") {
                jsonText = String(jsonText.dropFirst(7))
            } else if jsonText.hasPrefix("```") {
                jsonText = String(jsonText.dropFirst(3))
            }
            if jsonText.hasSuffix("```") {
                jsonText = String(jsonText.dropLast(3))
            }
            jsonText = jsonText.trimmingCharacters(in: .whitespacesAndNewlines)

            // 解析 JSON
            guard let jsonData = jsonText.data(using: .utf8) else {
                throw GeminiAPIError.invalidResponse
            }

            let geminiResponse = try JSONDecoder().decode(GeminiResponse.self, from: jsonData)
            return geminiResponse.toScamResult()

        } catch let error as DecodingError {
            throw GeminiAPIError.decodingError(error)
        } catch {
            throw error
        }
    }
}
