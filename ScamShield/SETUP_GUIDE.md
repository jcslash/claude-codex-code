# ScamShield Xcode 設定指南

這份指南將幫助您在 Xcode 中正確設定 ScamShield 專案。

## 前置需求

- macOS 13.0 或更新版本
- Xcode 14.0 或更新版本
- Apple Developer 帳號（用於真機測試，模擬器測試不需要）

## 完整設定步驟

### 1️⃣ 建立新的 Xcode 專案

1. 啟動 Xcode
2. 選擇 **File → New → Project**
3. 在模板選擇畫面：
   - 平台選擇 **iOS**
   - 選擇 **App** 模板
   - 點擊 **Next**

4. 專案設定：
   ```
   Product Name: ScamShield
   Team: [選擇您的開發團隊]
   Organization Identifier: com.[您的名稱]
   Bundle Identifier: com.[您的名稱].ScamShield
   Interface: SwiftUI
   Language: Swift
   ```
   - **不要勾選** Use Core Data
   - **不要勾選** Include Tests

5. 選擇儲存位置，點擊 **Create**

### 2️⃣ 設定部署目標

1. 在左側導覽列點擊專案檔案（藍色的 ScamShield 圖示）
2. 在 **TARGETS** 中選擇 **ScamShield**
3. 在 **General** tab：
   - **Minimum Deployments** 設為 **iOS 16.0**

### 3️⃣ 加入 Share Extension Target

1. 在專案設定頁面，點擊左下角的 **+** 按鈕（在 TARGETS 列表下方）
2. 在模板選擇畫面：
   - 選擇 **iOS** → **Share Extension**
   - 點擊 **Next**

3. Share Extension 設定：
   ```
   Product Name: ShareExtension
   Team: [選擇您的開發團隊]
   Language: Swift
   ```
   - 點擊 **Finish**

4. 當詢問 "Activate ShareExtension scheme?" 時，點擊 **Activate**

### 4️⃣ 整理專案結構

#### 建立資料夾群組

在 Xcode 左側導覽列中建立以下群組結構：

1. 在 **ScamShield** 資料夾上按右鍵 → **New Group**
2. 建立以下群組：
   ```
   ScamShield/
   ├── App
   ├── Views
   ├── ViewModels
   ├── Models (稍後會移到 Shared)
   └── Services (稍後會移到 Shared)
   ```

3. 在專案根目錄（與 ScamShield、ShareExtension 同層）建立 **Shared** 群組：
   - 在專案名稱上按右鍵 → **New Group**
   - 命名為 "Shared"
   - 在 Shared 內建立：
     ```
     Shared/
     ├── Models
     └── Services
     ```

### 5️⃣ 加入程式碼檔案

#### A. 主 App 檔案

**移動自動生成的檔案到對應群組：**

1. 將 `ScamShieldApp.swift` 拖曳到 **App** 群組
2. 將 `ContentView.swift` 拖曳到 **Views** 群組

**加入新檔案到 Views 群組：**

1. 右鍵點擊 **Views** 群組 → **New File**
2. 選擇 **SwiftUI View**
3. 建立以下檔案（每個檔案重複此步驟）：
   - `HistoryView.swift`
   - `QueryDetailView.swift`
   - `SettingsView.swift`

**加入 ViewModel：**

1. 右鍵點擊 **ViewModels** 群組 → **New File**
2. 選擇 **Swift File**
3. 命名為 `MainViewModel.swift`

#### B. Shared 檔案（重要：兩個 target 都要選）

**加入 Models：**

1. 右鍵點擊 **Shared/Models** 群組 → **New File**
2. 選擇 **Swift File**
3. 建立 `ScamResult.swift`
4. **重要**：在右側 **Target Membership** 同時勾選：
   - ✅ ScamShield
   - ✅ ShareExtension
5. 重複步驟 1-4 建立：
   - `ScamQuery.swift`
   - `User.swift`

**加入 Services：**

1. 右鍵點擊 **Shared/Services** 群組 → **New File**
2. 選擇 **Swift File**
3. 建立 `GeminiAPIService.swift`
4. **重要**：在右側 **Target Membership** 同時勾選：
   - ✅ ScamShield
   - ✅ ShareExtension

#### C. Share Extension 檔案

1. 找到自動生成的 `ShareViewController.swift`
2. 準備用新內容取代

### 6️⃣ 複製程式碼內容

現在將您已經生成的程式碼內容複製到對應的檔案中：

1. **主 App 檔案**：
   - 開啟 `ScamShield/ScamShield/App/ScamShieldApp.swift`
   - 複製新內容並取代原有內容

2. **Views**：
   - `ContentView.swift`
   - `HistoryView.swift`
   - `QueryDetailView.swift`
   - `SettingsView.swift`

3. **ViewModel**：
   - `MainViewModel.swift`

4. **Shared Models**：
   - `ScamResult.swift`
   - `ScamQuery.swift`
   - `User.swift`

5. **Shared Services**：
   - `GeminiAPIService.swift`

6. **Share Extension**：
   - `ShareViewController.swift`

### 7️⃣ 設定 Share Extension Info.plist

1. 在左側導覽列找到 **ShareExtension/Info.plist**
2. 開啟檔案
3. 找到 `NSExtension` → `NSExtensionAttributes` → `NSExtensionActivationRule`
4. 修改為以下設定：

```xml
<key>NSExtensionActivationRule</key>
<dict>
    <key>NSExtensionActivationSupportsText</key>
    <true/>
    <key>NSExtensionActivationSupportsWebURLWithMaxCount</key>
    <integer>1</integer>
</dict>
```

5. 確認 `NSExtensionPrincipalClass` 為：
```xml
<key>NSExtensionPrincipalClass</key>
<string>$(PRODUCT_MODULE_NAME).ShareViewController</string>
```

### 8️⃣ 設定 Signing & Capabilities

#### 主 App (ScamShield)

1. 選擇 **ScamShield** target
2. 進入 **Signing & Capabilities** tab
3. 設定：
   ```
   Team: [選擇您的開發團隊]
   Bundle Identifier: com.[您的名稱].ScamShield
   ```
4. 確認 **Automatically manage signing** 有勾選

#### Share Extension (ShareExtension)

1. 選擇 **ShareExtension** target
2. 進入 **Signing & Capabilities** tab
3. 設定：
   ```
   Team: [選擇您的開發團隊]
   Bundle Identifier: com.[您的名稱].ScamShield.ShareExtension
   ```
4. 確認 **Automatically manage signing** 有勾選

### 9️⃣ 編譯測試

1. 選擇模擬器（建議 iPhone 15 Pro 或 iPhone 14 Pro）
2. 按 **Cmd + B** 編譯專案
3. 解決任何編譯錯誤（通常是 import 或語法問題）
4. 編譯成功後按 **Cmd + R** 執行

### 🔟 測試 Share Extension

1. 在模擬器中開啟 **Notes** App
2. 輸入測試訊息：
   ```
   恭喜您中獎了！請點擊以下連結領取 iPhone 15 Pro Max 一台：
   https://bit.ly/xxxxx
   ```
3. 選取文字
4. 點擊 **Share** 按鈕
5. 在分享選單中找到 **ScamShield**（可能需要滑動到最後或點擊 More）
6. 點擊 ScamShield 圖示
7. 應該會看到分析畫面

## 常見問題

### Q1: Share Extension 沒有出現在分享選單中

**解決方法**：
1. 確認 ShareExtension target 已正確編譯
2. 重新安裝 App（刪除後重新 Run）
3. 檢查 Info.plist 中的 NSExtensionActivationRule 設定
4. 確認選取的是「文字」而不是圖片

### Q2: 編譯錯誤："Cannot find 'XXX' in scope"

**解決方法**：
1. 確認相關檔案已加入正確的 Target
2. 檢查 Shared 檔案的 Target Membership 是否兩個都勾選
3. 清理專案：**Product → Clean Build Folder** (Shift + Cmd + K)

### Q3: API 呼叫失敗

**解決方法**：
1. 確認網路連線正常
2. 檢查 API Key 是否正確
3. 查看 Console 輸出的錯誤訊息

### Q4: Share Extension 記憶體問題

**Share Extension 有嚴格的記憶體限制（約 120MB）**
- 避免載入大量資料
- 盡快完成處理並關閉
- 不要在 Extension 中做太複雜的操作

## 下一步

Phase 1 完成後，可以開始 Phase 2：

1. 整合 Firebase
2. 實作家人綁定功能
3. 加入 Push Notification
4. 設定 App Groups

## 需要幫助？

如果遇到問題，請檢查：
1. Xcode 版本是否符合要求
2. Bundle Identifier 是否設定正確
3. Target Membership 是否正確設定
4. 程式碼是否有語法錯誤

祝您開發順利！🚀
