# 大廠六週（Six Weeks Inside Big Tech）

一款瀏覽器 3D 模擬遊戲：選一家大公司入職，用六週走完一個績效週期，在壓力下做判斷，最後進入績效校準。

## 要解決的問題

「在大公司上班是什麼感覺？」多數人只能靠聽說。這款遊戲把大公司裡最常見、最影響績效的情境做成可以親手做選擇的關卡，讓玩家：

1. **體驗**：時間永遠不夠、請求永遠太多、影響力要被看見才算數。
2. **學會**：每個決定後都會說明背後的工作原則，並附上一個「明天就能在真實工作試」的練習。
3. **量化成長**：六項職場能力（問題定義、優先排序、溝通協作、技術判斷、主人翁、韌性）在結束時以雷達圖對比入職前後。

## 公司與角色

| 公司 | 角色 | 主要考驗 |
| --- | --- | --- |
| NVIDIA | CUDA 函式庫工程師 | Top 5 Things、speed-of-light 思考、One Team、年度發表節奏 |
| Meta | E4 軟體工程師（Reels 推薦） | 選團隊、code review、A/B 實驗與 guardrail、XFN 決策、組織重整、PSC 自評 |
| SpaceX | Starship 結構工程師 | 質疑需求、刪除零件、硬體測試迭代、安全與速度、surge、飛行後檢討 |

另有 5 個跨公司的突發狀況（會議轟炸、同事求助、電梯簡報、功勞被拿走、深夜訊息）。

## 玩法

- 每週 4 個時段，其中 1 個必須用在頭上有 **!** 的關鍵事件。
- 其餘時段自由分配：深度工作、1:1、跨組同步、喝咖啡、休息、公司專屬站點。
- 精力歸零會倦怠，損失時段與信任。
- 第 6 週後依 影響力 40% · 專案進度 25% · 信任 20% · 能見度 15% 計算評等（Meta 使用其公開的評等名稱，其他公司為模擬評等）。
- 工作手冊會跨公司、跨回合累積你學到的原則（存在瀏覽器本機）。

操作：點擊地面移動（手機可用），或 WASD / 方向鍵；靠近發光圓圈按 E 或點擊按鈕互動。

## 執行

直接用瀏覽器開啟 `index.html` 即可（需連網載入 Three.js r128 與 Google Fonts）。

- `game.html`：主體（Claude Artifact 格式，不含 `<html>` 外殼）
- `index.html`：可獨立開啟的版本 = 外殼 + `game.html`

修改 `game.html` 後重新產生 `index.html`：

```bash
{ echo '<!doctype html><html lang="zh-Hant"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover"></head><body>'; cat game.html; echo '</body></html>'; } > index.html
```

## 聲明

非官方模擬，與任何公司無關。情境依公開報導的企業文化與工作方法改編，人物皆為虛構。
