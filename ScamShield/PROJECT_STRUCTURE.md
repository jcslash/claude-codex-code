# ScamShield 專案結構說明

## 📁 完整目錄結構

```
ScamShield/
├── 📱 ScamShield/                      # 主 App
│   ├── App/
│   │   └── ScamShieldApp.swift        # App 進入點，定義 @main
│   ├── Views/
│   │   ├── ContentView.swift          # Tab View 主畫面
│   │   ├── HistoryView.swift          # 歷史紀錄列表頁面
│   │   ├── QueryDetailView.swift      # 查詢詳情頁面
│   │   └── SettingsView.swift         # 設定頁面
│   ├── ViewModels/
│   │   └── MainViewModel.swift        # 主要 ViewModel（管理查詢紀錄）
│   ├── Models/                         # (空的，Model 移到 Shared)
│   ├── Services/                       # (空的，Service 移到 Shared)
│   └── Resources/
│       └── Assets.xcassets            # 圖片資源
│
├── 📤 ShareExtension/                  # Share Extension
│   ├── ShareViewController.swift      # Extension 主控制器 + SwiftUI View
│   └── Info.plist                     # Extension 設定檔
│
├── 🔄 Shared/                          # 共用程式碼（兩個 target 都使用）
│   ├── Models/
│   │   ├── ScamResult.swift           # 分析結果 Model（風險等級、類型、說明）
│   │   ├── ScamQuery.swift            # 查詢紀錄 Model（包含內容和結果）
│   │   └── User.swift                 # 使用者 Model（Phase 2 使用）
│   └── Services/
│       └── GeminiAPIService.swift     # Gemini API 服務（呼叫 AI 分析）
│
└── 📄 文件/
    ├── README.md                      # 專案概述
    ├── SETUP_GUIDE.md                 # 詳細設定指南
    ├── QUICKSTART.md                  # 快速開始指南
    ├── FILE_CHECKLIST.md              # 檔案檢查清單
    ├── PROJECT_STRUCTURE.md           # 本檔案
    └── .gitignore                     # Git 忽略規則
```

## 📋 檔案功能說明

### 主 App (ScamShield Target)

#### `ScamShieldApp.swift`
- App 的進入點
- 建立 `MainViewModel` 並注入到環境中
- 設定 App 的根 View

#### `ContentView.swift`
- 主畫面，使用 TabView
- 包含兩個 Tab：歷史紀錄、設定

#### `HistoryView.swift`
- 顯示所有查詢紀錄的列表
- 每筆紀錄顯示：風險等級、訊息摘要、查詢時間
- 支援刪除紀錄
- 空白狀態提示

#### `QueryDetailView.swift`
- 顯示單筆查詢的詳細資訊
- 包含：風險等級、詐騙類型、分析說明、原始訊息

#### `SettingsView.swift`
- 設定頁面
- Phase 1：顯示使用說明、隱私權說明
- Phase 2：家人綁定、通知設定

#### `MainViewModel.swift`
- 主要的 ViewModel
- 管理查詢紀錄的載入、儲存、刪除
- Phase 1：使用 UserDefaults
- Phase 2：使用 Firestore

### Share Extension (ShareExtension Target)

#### `ShareViewController.swift`
- UIKit ViewController（Extension 的進入點）
- 提取分享的文字內容
- 建立並顯示 SwiftUI `ShareView`
- `ShareView`：
  - 顯示分析進度
  - 呼叫 Gemini API
  - 顯示分析結果
  - 儲存查詢紀錄

#### `Info.plist`
- Share Extension 的設定檔
- 定義可接受的內容類型（文字、URL）
- 設定 Extension 的顯示名稱

### Shared (兩個 Target 共用)

#### `ScamResult.swift`
- `RiskLevel` enum：high, medium, low
- `ScamResult` struct：
  - isScam: 是否為詐騙
  - confidence: 信心度（0-100）
  - reason: 分析說明
  - scamType: 詐騙類型
  - riskLevel: 風險等級（根據 confidence 自動計算）
- `GeminiResponse` struct：API 回應格式

#### `ScamQuery.swift`
- 查詢紀錄的資料結構
- 包含：使用者 ID、訊息內容、分析結果、查詢時間
- 提供摘要和格式化時間的計算屬性
- Firestore 轉換方法（Phase 2 使用）

#### `User.swift`
- 使用者資料結構
- 包含：email、建立時間、綁定的家人、FCM token
- Firestore 轉換方法（Phase 2 使用）

#### `GeminiAPIService.swift`
- Gemini API 的封裝服務
- `analyzeMessage(_:)`: 分析訊息
- `buildPrompt(for:)`: 建立分析 prompt
- `parseGeminiResponse(_:)`: 解析 API 回應
- 包含錯誤處理

## 🎯 Target Membership

### ScamShield Target
```
✅ ScamShieldApp.swift
✅ ContentView.swift
✅ HistoryView.swift
✅ QueryDetailView.swift
✅ SettingsView.swift
✅ MainViewModel.swift
✅ ScamResult.swift
✅ ScamQuery.swift
✅ User.swift
✅ GeminiAPIService.swift
```

### ShareExtension Target
```
✅ ShareViewController.swift
✅ Info.plist
✅ ScamResult.swift
✅ ScamQuery.swift
✅ User.swift
✅ GeminiAPIService.swift
```

### 共用檔案（兩個 Target 都要勾選）
```
✅✅ ScamResult.swift
✅✅ ScamQuery.swift
✅✅ User.swift
✅✅ GeminiAPIService.swift
```

## 🔄 資料流程

### 分析流程（Share Extension）

```
1. 使用者在其他 App 分享文字
   ↓
2. iOS 系統啟動 ShareExtension
   ↓
3. ShareViewController 提取分享內容
   ↓
4. ShareView 顯示分析中畫面
   ↓
5. GeminiAPIService 呼叫 API
   ↓
6. 解析 API 回應為 ScamResult
   ↓
7. 建立 ScamQuery 並儲存到 UserDefaults
   ↓
8. 顯示分析結果
   ↓
9. 使用者點擊「我知道了」關閉
```

### 查看歷史流程（主 App）

```
1. App 啟動
   ↓
2. MainViewModel 從 UserDefaults 載入查詢紀錄
   ↓
3. HistoryView 顯示紀錄列表
   ↓
4. 使用者點擊某筆紀錄
   ↓
5. 導航到 QueryDetailView
   ↓
6. 顯示完整的分析結果
```

## 📊 資料儲存

### Phase 1（當前）
- **位置**：UserDefaults.standard
- **Key**：`scam_queries`
- **格式**：JSON 編碼的 `[ScamQuery]` 陣列
- **限制**：無法跨裝置同步

### Phase 2（未來）
- **位置**：Firebase Firestore
- **Collection**：
  - `users/{userId}`：使用者資料
  - `queries/{queryId}`：查詢紀錄
- **優點**：跨裝置同步、家人共享

## 🎨 UI 設計原則

### 長輩友善設計
- **字體大小**：最小 17pt
- **按鈕大小**：最小 44x44pt
- **顏色對比**：高對比度
- **操作簡單**：步驟少、直覺

### 顏色定義
```swift
高風險：#DC2626（紅色）
中度可疑：#F59E0B（橘黃色）
安全：#10B981（綠色）
```

### 風險等級圖示
```
高風險：🔴
中度可疑：🟡
安全：🟢
```

## 🔧 技術細節

### API 整合
- **服務**：Google Gemini API
- **模型**：gemini-2.5-flash-lite
- **呼叫方式**：直接從 client 呼叫（Phase 1）
- **安全性**：API key 硬編碼（Phase 2 會移到 Keychain）

### 記憶體管理
- Share Extension 有嚴格的記憶體限制（約 120MB）
- 避免載入大量資料
- 盡快完成處理並關閉

### 執行時間限制
- Share Extension 有執行時間限制
- 長時間執行可能被系統終止
- 需要快速完成 API 呼叫

## 📱 App 狀態

### Phase 1 完成 ✅
- [x] 基本專案架構
- [x] Share Extension
- [x] Gemini API 整合
- [x] 分析結果顯示
- [x] 歷史紀錄
- [x] 本地儲存

### Phase 2 計劃 📋
- [ ] Firebase Authentication
- [ ] Firestore 資料庫
- [ ] App Groups（資料共享）
- [ ] 家人綁定
- [ ] Push Notification
- [ ] API Key 安全化

### Phase 3 計劃 🚀
- [ ] UI 精緻化
- [ ] App Icon
- [ ] 截圖準備
- [ ] TestFlight 測試
- [ ] App Store 上架

## 💡 開發建議

### 測試
- 使用 Notes App 測試分享功能
- 測試不同類型的詐騙訊息
- 測試網路錯誤情況

### 除錯
- 查看 Console 輸出
- 使用 Xcode debugger
- 檢查 API 回應格式

### 效能
- 監控記憶體使用
- 優化 API 呼叫
- 減少不必要的資料載入

## 📞 相關文件

- **README.md**：專案概述和快速說明
- **SETUP_GUIDE.md**：完整的 Xcode 設定步驟
- **QUICKSTART.md**：5 分鐘快速開始
- **FILE_CHECKLIST.md**：檔案清單和檢查項目

---

最後更新：2026-01-06
版本：Phase 1
