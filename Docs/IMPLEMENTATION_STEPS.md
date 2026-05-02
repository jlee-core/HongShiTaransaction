# 红十 トランザクションアプリ 実装手順

## 1. アプリ概要

このアプリは、中国のポーカーゲーム「红十」のゲーム終了時に、プレイヤーごとのポイント計算を補助するためのアプリである。

Minimum実装では、以下の機能を優先して実装する。

- プレイヤー名の入力
- 各プレイヤーのポイント初期値を `0` に設定
- 今回プレイするベースポイントの設定
- 順位の決定
- チームの決定
- 結果表示
- 精算処理
- まとめて精算処理

計算ルールは後から実装するため、最初は計算処理の構造だけ用意する。

---

## 2. アーキテクチャ

アーキテクチャは **MVVM** を採用する。

```text
Model        : データ構造
View         : 画面表示
ViewModel    : 状態管理・画面ロジック
Service      : 計算処理などの共通ロジック
```

---

## 3. 推奨ディレクトリ構成

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

## 4. Model設計

### Player

プレイヤー情報を管理する。

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

赤チーム・黒チームを表す。

```swift
enum TeamColor {
    case red
    case black
}
```

### GameResult

計算後の結果を表す。

```swift
struct GameResult {
    var players: [Player]
    var basePoint: Int
}
```

---

## 5. 画面フロー

### 画面1: 初期設定画面

画面名: `SetupView`

目的:

- プレイヤー名を入力する
- プレイヤーごとの初期ポイントを `0` にする
- 今回のベースポイントを入力する
- スタートボタンで順位決定画面へ遷移する

最低限必要なUI:

- プレイヤー名入力欄
- プレイヤー追加ボタン
- プレイヤーリスト表示
- ベースポイント入力欄
- スタートボタン

---

### 画面2: 順位決定画面

画面名: `RankingView`

タイトル:

```text
順位
```

目的:

- プレイヤー名をボタンリストで縦に表示する
- クリックした順番で順位を決定する
- 全員の順位が決まったら、チーム決定画面へ進む

最低限必要なUI:

- タイトル「順位」
- プレイヤー名のボタンリスト
- 選択済み順位の表示

動作:

1. プレイヤー名ボタンをタップする
2. タップ順に `rank` を設定する
3. 選択済みのプレイヤーは再選択できないようにする
4. 全員選択後、チーム決定画面へ遷移する

---

### 画面3: チーム決定画面

画面名: `TeamSelectionView`

タイトル:

```text
チームを決める
```

目的:

- 赤・黒のチーム色を選択する
- プレイヤー名をタップしてチームを割り当てる
- 選択されたプレイヤーを選択中の色で網線のように囲む
- 全員のチーム決定後、結果画面へ進む

最低限必要なUI:

- タイトル「チームを決める」
- 赤ボタン
- 黒ボタン
- プレイヤー名リスト
- 次へボタン

動作:

1. 赤または黒を選択する
2. プレイヤー名をタップする
3. 選択中の色をプレイヤーに設定する
4. 設定済みプレイヤーは、その色の枠線で表示する
5. 全員のチームが決まったら「次へ」ボタンを有効化する
6. 「次へ」を押すと計算処理を行い、結果画面へ遷移する

---

### 画面4: 結果画面

画面名: `ResultView`

目的:

- 計算結果を表示する
- 「精算する」または「まとめて精算」を選択する

最低限必要なUI:

- プレイヤーごとのポイント表示
- 精算するボタン
- まとめて精算ボタン

動作:

#### 精算する

- プレイヤーポイントをすべて初期化する
- 新たなゲームとして順位決定画面からスタートする

#### まとめて精算

- プレイヤーポイントは初期化しない
- 現在のポイントを保持したまま、順位決定画面から次のゲームを開始する

---

## 6. ViewModel設計

### SetupViewModel

責務:

- プレイヤー名の入力管理
- プレイヤー追加
- ベースポイント管理
- スタート可能かどうかの判定

主なプロパティ:

```swift
@Published var playerName: String = ""
@Published var players: [Player] = []
@Published var basePointText: String = ""
```

主なメソッド:

```swift
func addPlayer()
func canStart() -> Bool
```

---

### RankingViewModel

責務:

- 順位決定
- タップ順の管理
- 全員の順位が決まったかどうかの判定

主なプロパティ:

```swift
@Published var players: [Player]
```

主なメソッド:

```swift
func selectPlayer(_ player: Player)
func isRankingCompleted() -> Bool
```

---

### TeamSelectionViewModel

責務:

- 選択中のチーム色管理
- プレイヤーへのチーム割り当て
- 全員のチームが決まったかどうかの判定

主なプロパティ:

```swift
@Published var players: [Player]
@Published var selectedTeamColor: TeamColor = .red
```

主なメソッド:

```swift
func selectTeamColor(_ color: TeamColor)
func assignTeam(to player: Player)
func isTeamSelectionCompleted() -> Bool
```

---

### ResultViewModel

責務:

- 計算結果の保持
- 精算処理
- まとめて精算処理

主なプロパティ:

```swift
@Published var players: [Player]
let basePoint: Int
```

主なメソッド:

```swift
func settle()
func settleTogether()
```

---

## 7. ScoreCalculationService設計

計算ルールは後で実装するため、最初は仮実装にする。

```swift
final class ScoreCalculationService {
    func calculate(players: [Player], basePoint: Int) -> [Player] {
        // TODO: 红十の計算ルールを後で実装する
        return players
    }
}
```

---

## 8. Minimum実装の優先順位

### Step 1

- `Player` Modelを作成する
- `TeamColor` enumを作成する

### Step 2

- `SetupView` を作成する
- プレイヤー名入力と追加処理を実装する
- ベースポイント入力を実装する

### Step 3

- `RankingView` を作成する
- プレイヤー名ボタンを縦並びで表示する
- タップ順で順位を保存する

### Step 4

- `TeamSelectionView` を作成する
- 赤・黒の選択UIを作る
- プレイヤーにチーム色を設定する
- 選択済みプレイヤーを色付き枠線で表示する

### Step 5

- `ScoreCalculationService` を作成する
- 仮の計算処理を用意する

### Step 6

- `ResultView` を作成する
- プレイヤーごとのポイントを表示する
- 「精算する」「まとめて精算」ボタンを実装する

### Step 7

- 画面遷移を接続する
- 最低限の動作確認を行う

---

## 9. 後で追加する機能

- 正式な红十のポイント計算ルール
- プレイヤー人数の制限
- 入力バリデーション
- ゲーム履歴
- 累計ポイント管理
- データ永続化
- UI改善
- 多言語対応

---

## 10. 実装時の注意点

- Viewにはできるだけロジックを書かない
- 状態管理はViewModelにまとめる
- 計算処理はServiceに分離する
- Modelはシンプルに保つ
- Minimum実装では複雑なUIよりも動作フローを優先する
