# ScamShield 快速開始指南

這是一個快速設定指南，讓您在 5 分鐘內開始測試 ScamShield。

## 🚀 快速步驟

### 1. 在 Xcode 建立專案（2 分鐘）

```bash
# 在 macOS 上：
1. 打開 Xcode
2. File → New → Project
3. iOS → App
   - Product Name: ScamShield
   - Interface: SwiftUI
   - Language: Swift
4. Create
```

### 2. 加入 Share Extension（1 分鐘）

```bash
1. 點擊專案檔案
2. 點擊 "+" 新增 Target
3. iOS → Share Extension
   - Product Name: ShareExtension
4. Activate
```

### 3. 複製檔案（2 分鐘）

#### 建立資料夾結構

在 Xcode 中：
- 在專案根目錄建立 `Shared` 群組
- 在 Shared 內建立 `Models` 和 `Services` 群組

#### 重要：設定 Target Membership

將以下檔案加入專案時，**必須同時勾選兩個 target**：

**Shared/Models/**（Target: ScamShield + ShareExtension）
- `ScamResult.swift` ✅✅
- `ScamQuery.swift` ✅✅
- `User.swift` ✅✅

**Shared/Services/**（Target: ScamShield + ShareExtension）
- `GeminiAPIService.swift` ✅✅

**主 App**（Target: ScamShield）
- `ScamShieldApp.swift` ✅
- `ContentView.swift` ✅
- `HistoryView.swift` ✅
- `QueryDetailView.swift` ✅
- `SettingsView.swift` ✅
- `MainViewModel.swift` ✅

**Share Extension**（Target: ShareExtension）
- `ShareViewController.swift` ✅

### 4. 設定部署目標

兩個 target 都設為 **iOS 16.0**

### 5. 執行測試

```bash
Cmd + R → 執行
```

## 📱 測試流程

### 測試訊息範例

在 Notes App 或 Safari 中測試以下訊息：

**高風險詐騙（投資詐騙）**
```
🔥 穩賺不賠！保證月收益 30%！
立即加入我的 LINE：@invest888
前 100 名免費教學，錯過不再有！
```

**高風險詐騙（假冒銀行）**
```
【重要通知】
您的信用卡出現異常交易，
請立即點擊連結驗證身份：
https://bank-verify.com/xxxxx
否則將凍結帳戶。
```

**中度可疑（釣魚連結）**
```
限時優惠！iPhone 15 Pro Max 只要 $9,999
點擊連結立即搶購：https://bit.ly/iphone-sale
```

**安全訊息**
```
媽，我今天晚點回家吃飯，
公司有個會議要開。
```

### 測試步驟

1. 開啟 Notes App
2. 貼上測試訊息
3. 選取文字
4. 點擊「分享」
5. 選擇「ScamShield」
6. 查看分析結果
7. 回到主 App 查看歷史紀錄

## ✅ 檢查清單

完成以下檢查，確保專案設定正確：

- [ ] Xcode 專案已建立
- [ ] ShareExtension target 已加入
- [ ] 所有 Shared 檔案的 Target Membership 都勾選了兩個 target
- [ ] iOS Deployment Target 設為 16.0
- [ ] 編譯成功（Cmd + B 無錯誤）
- [ ] 主 App 可以執行
- [ ] Share Extension 出現在分享選單中
- [ ] 可以成功分析訊息
- [ ] 歷史紀錄有顯示

## 🐛 快速除錯

### Share Extension 沒出現？

```bash
1. 確認 Info.plist 設定正確
2. 重新安裝 App（刪除後重新 Run）
3. 確認選取的是「文字」
```

### 編譯錯誤？

```bash
1. Product → Clean Build Folder (Shift + Cmd + K)
2. 檢查 Shared 檔案的 Target Membership
3. 確認所有 import 語句正確
```

### API 呼叫失敗？

```bash
1. 檢查網路連線
2. 確認 GeminiAPIService.swift 中的 API Key
3. 查看 Console 的錯誤訊息
```

## 📊 預期結果

成功執行後，您應該看到：

1. **分析畫面**：
   - 顯示風險等級（紅/黃/綠）
   - 顯示詐騙類型
   - 顯示分析說明
   - 可展開查看原始訊息

2. **歷史紀錄**：
   - 列出所有查詢
   - 顯示風險等級圖示
   - 顯示訊息摘要
   - 顯示查詢時間

3. **詳情頁面**：
   - 完整的分析結果
   - 原始訊息內容
   - 查詢時間

## 🎯 下一步

Phase 1 完成！接下來可以：

1. **調整 UI**：修改顏色、字體大小
2. **測試更多情境**：不同類型的詐騙訊息
3. **準備 Phase 2**：
   - 整合 Firebase
   - 加入家人綁定
   - 實作推播通知

## 💡 小提示

- **記憶體限制**：Share Extension 有嚴格的記憶體限制，保持程式碼簡潔
- **執行時間**：盡快完成分析並關閉，避免被系統終止
- **錯誤處理**：網路問題很常見，要有良好的錯誤提示
- **長輩友善**：字體要夠大（17pt+），按鈕要夠大（44pt+）

## 📞 需要協助？

遇到問題時：
1. 檢查 Console 輸出
2. 確認專案設定
3. 參考完整的 SETUP_GUIDE.md

開始測試您的 ScamShield 吧！🛡️
