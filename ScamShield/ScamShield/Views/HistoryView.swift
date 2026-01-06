//
//  HistoryView.swift
//  ScamShield
//
//  Created on 2026-01-06.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var viewModel: MainViewModel

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.queries.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "shield.checkered")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)

                        Text("還沒有查詢紀錄")
                            .font(.title2)
                            .foregroundColor(.gray)

                        Text("從任何 App 分享可疑訊息\n給 ScamShield 來檢測")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(viewModel.queries) { query in
                            NavigationLink(destination: QueryDetailView(query: query)) {
                                QueryRowView(query: query)
                            }
                        }
                        .onDelete(perform: deleteQueries)
                    }
                }
            }
            .navigationTitle("ScamShield 詐騙盾")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private func deleteQueries(at offsets: IndexSet) {
        for index in offsets {
            viewModel.deleteQuery(viewModel.queries[index])
        }
    }
}

struct QueryRowView: View {
    let query: ScamQuery

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // 風險等級圖示
            Text(query.result.riskLevel.emoji)
                .font(.system(size: 30))

            VStack(alignment: .leading, spacing: 4) {
                // 訊息摘要
                Text(query.summary)
                    .font(.system(size: 17))
                    .lineLimit(2)

                // 判斷結果
                HStack(spacing: 8) {
                    Text(query.result.riskLevel.displayName)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(colorFromHex(query.result.riskLevel.color))

                    Text("•")
                        .foregroundColor(.secondary)

                    Text(query.result.scamType)
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                }

                // 時間
                Text(query.formattedDate)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
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
    HistoryView()
        .environmentObject(MainViewModel())
}
