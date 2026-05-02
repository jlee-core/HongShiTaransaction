# HongShiTransaction 追加仕様修正指示

## 対象

SwiftUI + MVVM 構成の既存プロジェクト

---

## 1. ベースポイントの引き継ぎ仕様

### 「次のゲームへ」クリック時

- 前回のゲームで使用した `basePoint` を引き継ぐ

- PortalView に遷移した際の初期値として表示する

### 条件

- ユーザーは値を変更可能とする（固定しない）

```swift
// 例
basePoint = previousGameBasePoint
