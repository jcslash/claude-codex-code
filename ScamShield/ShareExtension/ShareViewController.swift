//
//  ShareViewController.swift
//  ShareExtension
//
//  Created on 2026-01-06.
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers

class ShareViewController: UIViewController {
    private var hostingController: UIHostingController<ShareView>?
    private var sharedText: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // 提取分享的內容
        extractSharedContent { [weak self] text in
            guard let self = self else { return }

            if let text = text, !text.isEmpty {
                self.sharedText = text
                self.setupShareView()
            } else {
                self.showError("無法取得分享的內容")
            }
        }
    }

    private func setupShareView() {
        guard let sharedText = sharedText else { return }

        let shareView = ShareView(
            sharedText: sharedText,
            onDismiss: { [weak self] in
                self?.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
            }
        )

        let hostingController = UIHostingController(rootView: shareView)
        self.hostingController = hostingController

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostingController.didMove(toParent: self)
    }

    private func extractSharedContent(completion: @escaping (String?) -> Void) {
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
              let itemProvider = extensionItem.attachments?.first else {
            completion(nil)
            return
        }

        // 嘗試提取文字
        if itemProvider.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) {
            itemProvider.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { (item, error) in
                DispatchQueue.main.async {
                    if let text = item as? String {
                        completion(text)
                    } else if let data = item as? Data, let text = String(data: data, encoding: .utf8) {
                        completion(text)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
        // 嘗試提取 URL（有些 App 會以 URL 形式分享）
        else if itemProvider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
            itemProvider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { (item, error) in
                DispatchQueue.main.async {
                    if let url = item as? URL {
                        completion(url.absoluteString)
                    } else {
                        completion(nil)
                    }
                }
            }
        } else {
            completion(nil)
        }
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "錯誤", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default) { [weak self] _ in
            self?.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        })
        present(alert, animated: true)
    }
}

// MARK: - ShareView (SwiftUI)

struct ShareView: View {
    let sharedText: String
    let onDismiss: () -> Void

    @State private var isAnalyzing = false
    @State private var result: ScamResult?
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                if isAnalyzing {
                    analyzingView
                } else if let result = result {
                    resultView(result: result)
                } else if let errorMessage = errorMessage {
                    errorView(message: errorMessage)
                } else {
                    EmptyView()
                }
            }
            .navigationTitle("ScamShield")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("關閉") {
                        onDismiss()
                    }
                }
            }
        }
        .task {
            await analyzeMessage()
        }
    }

    private var analyzingView: some View {
        VStack(spacing: 24) {
            ProgressView()
                .scaleEffect(1.5)

            Text("分析中...")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.secondary)

            Text("正在檢查這則訊息是否為詐騙")
                .font(.system(size: 17))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    private func resultView(result: ScamResult) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                // 風險等級標題
                VStack(spacing: 16) {
                    Text(result.riskLevel.emoji)
                        .font(.system(size: 80))

                    Text(result.riskLevel.displayName)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(colorFromHex(result.riskLevel.color))
                }
                .padding(.top, 32)

                // 詐騙類型與說明
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(result.scamType)
                            .font(.system(size: 24, weight: .semibold))
                        Spacer()
                    }

                    Text(result.reason)
                        .font(.system(size: 20))
                        .lineSpacing(6)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)

                // 原始訊息（可展開）
                DisclosureGroup {
                    Text(sharedText)
                        .font(.system(size: 17))
                        .lineSpacing(4)
                        .padding(.top, 12)
                } label: {
                    Text("原始訊息")
                        .font(.system(size: 17, weight: .semibold))
                }
                .padding(20)
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)

                // 完成按鈕
                Button(action: onDismiss) {
                    Text("我知道了")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.blue)
                        .cornerRadius(16)
                }
                .padding(.top, 16)
            }
            .padding()
        }
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 24) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.orange)

            Text("分析失敗")
                .font(.system(size: 24, weight: .bold))

            Text(message)
                .font(.system(size: 17))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: onDismiss) {
                Text("關閉")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.blue)
                    .cornerRadius(16)
            }
            .padding(.horizontal)
        }
        .padding()
    }

    private func analyzeMessage() async {
        isAnalyzing = true
        errorMessage = nil

        do {
            let result = try await GeminiAPIService.shared.analyzeMessage(sharedText)
            self.result = result

            // 儲存查詢紀錄
            saveQuery(result: result)
        } catch {
            errorMessage = "分析時發生錯誤：\(error.localizedDescription)"
        }

        isAnalyzing = false
    }

    private func saveQuery(result: ScamResult) {
        let query = ScamQuery(
            userId: "demo_user",
            content: sharedText,
            result: result
        )

        // 儲存到 UserDefaults（Phase 1）
        var queries: [ScamQuery] = []
        if let data = UserDefaults.shared.data(forKey: "scam_queries"),
           let decoded = try? JSONDecoder().decode([ScamQuery].self, from: data) {
            queries = decoded
        }

        queries.insert(query, at: 0)

        if let encoded = try? JSONEncoder().encode(queries) {
            UserDefaults.shared.set(encoded, forKey: "scam_queries")
        }
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
    ShareView(
        sharedText: "恭喜您中獎了！請點擊連結領取 iPhone 15 Pro Max",
        onDismiss: {}
    )
}
