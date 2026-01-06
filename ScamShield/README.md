# ScamShield（詐騙盾）

一個 iOS App，讓長輩能透過「分享」功能快速檢測可疑訊息是否為詐騙。

## 專案狀態

✅ Phase 1 完成
- 基本專案架構
- Share Extension 功能
- Gemini API 整合
- 歷史紀錄顯示

## 功能特色

- 🛡️ 快速檢測詐騙訊息
- 📱 從任何 App 分享訊息來檢測
- 🤖 使用 Gemini AI 分析
- 📊 三級風險評估（高/中/低）
- 📝 詳細分析說明
- 📚 歷史查詢紀錄

## 在 Xcode 中建立專案

由於這些檔案是在 Linux 環境中生成的，您需要在 macOS 上用 Xcode 建立專案。請依照以下步驟：

### 步驟 1：建立新專案

1. 打開 Xcode
2. File → New → Project
3. 選擇 "iOS" → "App"
4. 設定如下：
   - Product Name: `ScamShield`
   - Team: 選擇您的開發團隊
   - Organization Identifier: 例如 `com.yourname`
   - Interface: `SwiftUI`
   - Language: `Swift`
   - Storage: 不勾選 Core Data
   - 不勾選 Include Tests

### 步驟 2：加入 Share Extension Target

1. 在 Xcode 中，點擊專案檔案（左側導覽列最上方的藍色圖示）
2. 點擊下方的 "+" 按鈕來新增 Target
3. 選擇 "iOS" → "Share Extension"
4. 設定如下：
   - Product Name: `ShareExtension`
   - Language: `Swift`
   - 點擊 "Finish"
5. 當詢問是否啟用 scheme 時，選擇 "Activate"

### 步驟 3：複製程式碼檔案

將以下檔案從 `ScamShield/` 目錄複製到 Xcode 專案中：

#### 主 App 檔案
- `ScamShield/App/ScamShieldApp.swift` → 取代 Xcode 自動生成的 `ScamShieldApp.swift`
- `ScamShield/Views/ContentView.swift` → 取代自動生成的 `ContentView.swift`
- `ScamShield/Views/HistoryView.swift`
- `ScamShield/Views/QueryDetailView.swift`
- `ScamShield/Views/SettingsView.swift`
- `ScamShield/ViewModels/MainViewModel.swift`

#### Shared 檔案（主 App 和 Extension 都要加入）
將這些檔案拖入 Xcode 時，確保兩個 target 都勾選：
- `Shared/Models/ScamResult.swift`
- `Shared/Models/ScamQuery.swift`
- `Shared/Models/User.swift`
- `Shared/Services/GeminiAPIService.swift`

#### Share Extension 檔案
- `ShareExtension/ShareViewController.swift` → 取代自動生成的檔案
- `ShareExtension/Info.plist` → 取代自動生成的檔案

### 步驟 4：設定專案設定

1. 點擊專案檔案
2. 選擇 "ScamShield" target
3. 在 "Signing & Capabilities" 中：
   - 選擇您的 Team
   - Bundle Identifier 會自動生成（例如 `com.yourname.ScamShield`）

4. 選擇 "ShareExtension" target
5. 在 "Signing & Capabilities" 中：
   - 選擇您的 Team
   - Bundle Identifier 會自動生成（例如 `com.yourname.ScamShield.ShareExtension`）

### 步驟 5：設定 iOS 部署目標

1. 選擇 "ScamShield" target
2. 在 "General" → "Deployment Info"
3. 設定 "Minimum Deployments" 為 iOS 16.0

4. 對 "ShareExtension" target 做相同設定

### 步驟 6：編譯並執行

1. 選擇一個模擬器或真機
2. 按 Cmd+B 編譯專案
3. 按 Cmd+R 執行

## 測試 Share Extension

1. 在模擬器或真機上執行 App
2. 打開其他 App（例如 Notes、Safari）
3. 選取一段可疑文字（例如：「恭喜您中獎！請點擊連結領取 iPhone」）
4. 點擊「分享」
5. 選擇「ScamShield」
6. 查看分析結果

## 專案結構

```
ScamShield/
├── ScamShield/                    # 主 App
│   ├── App/
│   │   └── ScamShieldApp.swift   # App 進入點
│   ├── Views/
│   │   ├── ContentView.swift     # 主畫面（Tab View）
│   │   ├── HistoryView.swift     # 歷史紀錄列表
│   │   ├── QueryDetailView.swift # 查詢詳情頁面
│   │   └── SettingsView.swift    # 設定頁面
│   └── ViewModels/
│       └── MainViewModel.swift   # 主要 ViewModel
├── ShareExtension/                # Share Extension
│   ├── ShareViewController.swift # Extension 控制器與 UI
│   └── Info.plist               # Extension 設定
└── Shared/                        # 共用程式碼
    ├── Models/
    │   ├── ScamResult.swift      # 分析結果 Model
    │   ├── ScamQuery.swift       # 查詢記錄 Model
    │   └── User.swift            # 使用者 Model
    └── Services/
        └── GeminiAPIService.swift # Gemini API 服務
```

## 技術架構

- **前端**: SwiftUI
- **AI 分析**: Google Gemini 2.5 Flash Lite API
- **資料儲存**: UserDefaults（Phase 1）
- **iOS 版本**: iOS 16.0+

## Phase 2 計劃

- [ ] Firebase Authentication
- [ ] Firestore 資料庫
- [ ] 家人綁定功能
- [ ] Push Notification
- [ ] App Groups（主 App 和 Extension 共享資料）

## 授權

MIT License
