# HongShiTransaction

## 概要

HongShiTransaction は、中国のポーカーゲーム「红十」のゲーム終了時に、プレイヤーごとのポイント計算を補助するためのSwiftUIアプリです。

Minimum実装では、ゲーム終了後の順位決定、チーム決定、ポイント計算、精算処理までの基本フローを実装します。

正式な計算ルールは後から追加する予定です。

---

## 目的

このアプリの目的は、红十のゲーム終了時に発生するポイント計算を簡単にし、プレイヤーごとの累計ポイントを管理しやすくすることです。

---

## 使用技術

- Swift
- SwiftUI
- MVVM Architecture

---

## アーキテクチャ

このアプリでは MVVM を採用します。

```text
Model      : プレイヤー情報、チーム情報、結果情報などのデータ
View       : SwiftUIによる画面表示
ViewModel  : 状態管理、ユーザー操作、画面ロジック
Service    : ポイント計算などの共通処理
```

---

## Minimum実装の機能

### 1. プレイヤー設定

最初の画面でプレイヤー名を入力します。

各プレイヤーは初期値 `0` のポイントを持ちます。

### 2. ベースポイント設定

今回プレイするゲームのベースポイントを入力します。

### 3. 順位決定

スタート後、画面遷移して順位決定画面を表示します。

画面タイトルは以下です。

```text
順位
```

プレイヤー名が縦並びのボタンリストとして表示されます。

プレイヤー名をクリックした順番で順位を決定します。

### 4. チーム決定

順位決定後、チーム決定画面を表示します。

画面タイトルは以下です。

```text
チームを決める
```

赤と黒の色を選択し、プレイヤー名をクリックしてチームを決めます。

選択されたプレイヤーは、選択された色で網線のような枠で囲まれます。

全員のチームが決まったら、下の「次へ」ボタンをクリックします。

### 5. 結果表示

「次へ」をクリックするとポイント計算を行い、結果画面を表示します。

計算ルールは後で実装するため、Minimum実装では計算処理の土台のみ作成します。

### 6. 精算処理

結果画面には以下のボタンを表示します。

```text
精算する
まとめて精算
```

#### 精算する

プレイヤーのポイントをすべて初期化します。

その後、新しいゲームとして順位決定画面からスタートします。

#### まとめて精算

プレイヤーのポイントは初期化しません。

現在のポイントを保持したまま、次のゲームとして順位決定画面からスタートします。

---

## 画面一覧

| 画面名 | 役割 |
|---|---|
| SetupView | プレイヤー名とベースポイントを設定する |
| RankingView | プレイヤーの順位を決定する |
| TeamSelectionView | 赤・黒のチームを決定する |
| ResultView | 計算結果を表示し、精算処理を行う |

---

## ディレクトリ構成

```text
HongShiTransactionApp
├── Models
│   ├── Player.swift
│   ├── TeamColor.swift
│   └── GameResult.swift
│
├── ViewModels
│   ├── SetupViewModel.swift
│   ├── RankingViewModel.swift
│   ├── TeamSelectionViewModel.swift
│   └── ResultViewModel.swift
│
├── Views
│   ├── SetupView.swift
│   ├── RankingView.swift
│   ├── TeamSelectionView.swift
│   └── ResultView.swift
│
├── Services
│   └── ScoreCalculationService.swift
│
└── HongShiTransactionApp.swift
```

---

## データモデル案

### Player

```swift
struct Player: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var point: Int = 0
    var rank: Int?
    var teamColor: TeamColor?
}
```

### TeamColor

```swift
enum TeamColor {
    case red
    case black
}
```

---

## 今後追加する予定

- 红十の正式なポイント計算ルール
- ゲーム履歴保存
- 累計ポイント表示
- データ永続化
- プレイヤー人数制限
- UI改善
- 多言語対応

---

## 開発方針

Minimum実装では、まず画面遷移と状態管理を完成させます。

ポイント計算ルールは後から `ScoreCalculationService` に追加します。

Viewにはできるだけロジックを書かず、状態管理と処理はViewModelに分離します。
