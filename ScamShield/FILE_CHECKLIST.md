# ScamShield 檔案檢查清單

使用這個清單確保所有必要的檔案都已正確加入 Xcode 專案。

## ✅ 檔案清單

### 📱 主 App (Target: ScamShield)

#### App/
- [ ] `ScamShieldApp.swift` - App 進入點
  - Target: ✅ ScamShield

#### Views/
- [ ] `ContentView.swift` - 主畫面（Tab View）
  - Target: ✅ ScamShield
- [ ] `HistoryView.swift` - 歷史紀錄列表
  - Target: ✅ ScamShield
- [ ] `QueryDetailView.swift` - 查詢詳情頁面
  - Target: ✅ ScamShield
- [ ] `SettingsView.swift` - 設定頁面
  - Target: ✅ ScamShield

#### ViewModels/
- [ ] `MainViewModel.swift` - 主要 ViewModel
  - Target: ✅ ScamShield

### 🔄 Shared (Target: ScamShield + ShareExtension)

#### Shared/Models/
- [ ] `ScamResult.swift` - 分析結果 Model
  - Target: ✅ ScamShield ✅ ShareExtension
- [ ] `ScamQuery.swift` - 查詢記錄 Model
  - Target: ✅ ScamShield ✅ ShareExtension
- [ ] `User.swift` - 使用者 Model
  - Target: ✅ ScamShield ✅ ShareExtension

#### Shared/Services/
- [ ] `GeminiAPIService.swift` - Gemini API 服務
  - Target: ✅ ScamShield ✅ ShareExtension

### 📤 Share Extension (Target: ShareExtension)

- [ ] `ShareViewController.swift` - Extension 控制器與 UI
  - Target: ✅ ShareExtension
- [ ] `Info.plist` - Extension 設定
  - Target: ✅ ShareExtension

### 📄 文件檔案（不需加入 Xcode）

- [ ] `README.md` - 專案說明
- [ ] `SETUP_GUIDE.md` - 詳細設定指南
- [ ] `QUICKSTART.md` - 快速開始指南
- [ ] `FILE_CHECKLIST.md` - 本檔案
- [ ] `.gitignore` - Git 忽略規則

## 📋 檔案內容快速檢查

### ScamShieldApp.swift
```swift
@main
struct ScamShieldApp: App {
    @StateObject private var viewModel = MainViewModel()
    // ...
}
```

### ContentView.swift
```swift
struct ContentView: View {
    @State private var selectedTab = 0
    // TabView with HistoryView and SettingsView
}
```

### HistoryView.swift
```swift
struct HistoryView: View {
    @EnvironmentObject var viewModel: MainViewModel
    // List of ScamQuery
}
```

### QueryDetailView.swift
```swift
struct QueryDetailView: View {
    let query: ScamQuery
    // Detailed view of analysis result
}
```

### SettingsView.swift
```swift
struct SettingsView: View {
    // Settings and about information
}
```

### MainViewModel.swift
```swift
@MainActor
class MainViewModel: ObservableObject {
    @Published var queries: [ScamQuery] = []
    // ...
}
```

### ScamResult.swift
```swift
enum RiskLevel: String, Codable {
    case high, medium, low
}

struct ScamResult: Codable, Identifiable {
    // ...
}
```

### ScamQuery.swift
```swift
struct ScamQuery: Codable, Identifiable {
    let id: String
    let userId: String
    let content: String
    let result: ScamResult
    let createdAt: Date
}
```

### User.swift
```swift
struct User: Codable, Identifiable {
    let id: String
    let email: String
    let createdAt: Date
    var linkedFamily: [String]
    var fcmToken: String?
}
```

### GeminiAPIService.swift
```swift
class GeminiAPIService {
    static let shared = GeminiAPIService()
    private let apiKey = "AIzaSyB_H4SBMggzumEpaDou-kgtGTggw3Yy0sg"
    // ...
}
```

### ShareViewController.swift
```swift
class ShareViewController: UIViewController {
    // Extract shared content and show ShareView
}

struct ShareView: View {
    let sharedText: String
    let onDismiss: () -> Void
    // Analysis UI
}
```

## 🎯 Target Membership 重要提醒

### 必須同時勾選兩個 target 的檔案：

這些檔案會被主 App 和 Share Extension 共用：

1. ✅✅ `Shared/Models/ScamResult.swift`
2. ✅✅ `Shared/Models/ScamQuery.swift`
3. ✅✅ `Shared/Models/User.swift`
4. ✅✅ `Shared/Services/GeminiAPIService.swift`

### 檢查方法：

1. 在 Xcode 中點擊檔案
2. 查看右側的 **File Inspector**
3. 在 **Target Membership** 區域確認勾選狀態

## 🔍 快速驗證

### 編譯檢查

```bash
# ScamShield target
Cmd + B → 應該成功編譯

# ShareExtension target
選擇 ShareExtension scheme → Cmd + B → 應該成功編譯
```

### 執行檢查

```bash
# 執行主 App
Cmd + R → App 啟動
→ 看到歷史紀錄空白頁面（首次執行）

# 測試 Share Extension
開啟 Notes → 輸入文字 → 分享 → 選擇 ScamShield
→ 看到分析畫面
```

## 📊 專案結構樹狀圖

```
ScamShield.xcodeproj
├── ScamShield
│   ├── App
│   │   └── ScamShieldApp.swift
│   ├── Views
│   │   ├── ContentView.swift
│   │   ├── HistoryView.swift
│   │   ├── QueryDetailView.swift
│   │   └── SettingsView.swift
│   ├── ViewModels
│   │   └── MainViewModel.swift
│   └── Assets.xcassets
├── ShareExtension
│   ├── ShareViewController.swift
│   └── Info.plist
└── Shared
    ├── Models
    │   ├── ScamResult.swift
    │   ├── ScamQuery.swift
    │   └── User.swift
    └── Services
        └── GeminiAPIService.swift
```

## ⚠️ 常見遺漏

檢查以下常見問題：

- [ ] Shared 檔案忘記勾選 ShareExtension target
- [ ] ShareViewController.swift 忘記勾選 ShareExtension target
- [ ] Info.plist 設定不正確
- [ ] 部署目標（Deployment Target）不是 iOS 16.0
- [ ] Bundle Identifier 設定錯誤

## ✨ 全部完成！

如果所有檢查都通過，您的專案已經準備好了！

下一步：
1. 執行 App
2. 測試 Share Extension
3. 檢查功能是否正常

如果遇到問題，請參考 `SETUP_GUIDE.md` 或 `QUICKSTART.md`。
