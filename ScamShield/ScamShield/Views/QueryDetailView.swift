//
//  QueryDetailView.swift
//  ScamShield
//
//  Created on 2026-01-06.
//

import SwiftUI

struct QueryDetailView: View {
    let query: ScamQuery

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 風險等級標題
                VStack(spacing: 12) {
                    Text(query.result.riskLevel.emoji)
                        .font(.system(size: 60))

                    Text(query.result.riskLevel.displayName)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(colorFromHex(query.result.riskLevel.color))

                    Text("信心度：\(query.result.confidence)%")
                        .font(.system(size: 17))
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)

                // 詐騙類型
                VStack(alignment: .leading, spacing: 12) {
                    Text("類型")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.secondary)

                    Text(query.result.scamType)
                        .font(.system(size: 20, weight: .medium))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)

                // 分析說明
                VStack(alignment: .leading, spacing: 12) {
                    Text("分析說明")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.secondary)

                    Text(query.result.reason)
                        .font(.system(size: 20))
                        .lineSpacing(4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)

                // 原始訊息
                VStack(alignment: .leading, spacing: 12) {
                    Text("原始訊息")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.secondary)

                    Text(query.content)
                        .font(.system(size: 17))
                        .lineSpacing(4)
                        .textSelection(.enabled)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)

                // 查詢時間
                Text("查詢時間：\(query.formattedDate)")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .navigationTitle("查詢詳情")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func colorFromHex(_ hex: String) -> Color {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255.0
        let g = Double((int >> 8) & 0xFF) / 255.0
        let b = Double(int & 0xFF) / 255.0
        return Color(red: r, green: g, blue: b)
    }
}

#Preview {
    NavigationStack {
        QueryDetailView(query: ScamQuery(
            userId: "demo",
            content: "恭喜您！您已被選中獲得 iPhone 15 Pro Max 一台，請點擊以下連結領取：https://bit.ly/xxxxx",
            result: ScamResult(
                isScam: true,
                confidence: 95,
                reason: "這是典型的中獎詐騙，要求點擊不明連結，真正的抽獎活動不會這樣通知。",
                scamType: "中獎詐騙"
            )
        ))
    }
}
