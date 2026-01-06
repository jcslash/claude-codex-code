//
//  SettingsView.swift
//  ScamShield
//
//  Created on 2026-01-06.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("關於")
                }

                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("使用說明")
                            .font(.system(size: 17, weight: .semibold))

                        Text("1️⃣ 在任何 App 中長按可疑訊息")
                            .font(.system(size: 17))

                        Text("2️⃣ 點擊「分享」")
                            .font(.system(size: 17))

                        Text("3️⃣ 選擇「ScamShield」")
                            .font(.system(size: 17))

                        Text("4️⃣ 查看分析結果")
                            .font(.system(size: 17))
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("如何使用")
                }

                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("您分享的訊息會傳送到 Gemini AI 進行分析，但不會儲存在我們的伺服器上。")
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)

                        Text("分析結果會儲存在您的裝置上，僅供您查看。")
                            .font(.system(size: 15))
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("隱私權")
                }

                // Phase 2 會加入這些功能
                /*
                Section {
                    NavigationLink("綁定家人") {
                        FamilyLinkView()
                    }

                    Toggle("通知提醒", isOn: $notificationEnabled)
                } header: {
                    Text("家人通知")
                } footer: {
                    Text("當檢測到中高風險詐騙時，會通知您的家人")
                }
                */
            }
            .navigationTitle("設定")
        }
    }
}

#Preview {
    SettingsView()
}
