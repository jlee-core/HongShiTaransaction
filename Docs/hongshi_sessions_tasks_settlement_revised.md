# HongShiTransaction 実装修正タスク（Session分割・精算仕様修正版）

## 目的
ResultView / SettlementView / ゲームログ / 最終精算 / 初期化処理の仕様を明確にする。  
Codexは本ファイルの内容を優先して実装すること。

---

## Session 1：ResultView のボタン文言変更

ResultView のボタン文言を以下のように変更する。

### 変更前
- 精算する
- まとめて精算

### 変更後
- 次のゲームへ
- 精算する

---

## Session 2：ベースポイント初期値変更

ベースポイントの初期値を `0` に変更する。

```swift
basePoint = 0
```

---

## Session 3：倍率イベント修正

現在の倍率イベントを以下に変更する。

### 新しい倍率イベント
- 亮牌
- 顶牌
- 踢
- 反踢

各イベントはオン / オフで管理する。  
選択されたイベント1つにつき、最終ベースポイントを2倍にする。

### 計算式

```text
finalBasePoint = basePoint × 2^eventCount
```

### 例

```text
basePoint = 20
亮牌 = true
顶牌 = true
踢 = true
反踢 = true

finalBasePoint = 20 × 2 × 2 × 2 × 2 = 320
```

---

## Session 4：PortalView の入力制御

PortalView では、ベースポイントが必ず入力されていて、かつ `0より大きい` 場合のみゲーム開始できるようにする。

### 開始条件

```swift
basePoint > 0
```

条件を満たさない場合：

- スタートボタンを disabled にする
- エラーメッセージを表示する

例：

```text
ベースポイントを1以上で入力してください
```

---

## Session 5：次のゲームへの遷移仕様

ResultView の「次のゲームへ」を押した場合、RankingView ではなく PortalView に戻る。

理由：

- 倍率イベントは毎ゲーム異なる
- ベースポイントも毎ゲーム設定する必要がある

### 維持する情報
- プレイヤー一覧
- プレイヤーごとの累計ポイント
- ゲームログ

### 初期化する情報
- 今回の順位
- 今回のチーム選択
- 今回のベースポイント
- 今回の倍率イベント
- 今回の計算結果

---

## Session 6：PortalView のユーザー編集制御

2ゲーム目以降に PortalView に戻った場合、プレイヤー名は変更できないようにする。

### 条件例

```swift
isGameStartedOnce == true
```

この場合：

- プレイヤー名入力 TextField を disabled にする
- 既存プレイヤー名は表示のみ、または編集不可状態にする

---

## Session 7：ゲームログ仕様

各ゲーム終了時に、そのゲーム内で発生した支払いログを保存する。

### 表示する内容

ゲームログには以下のみ記載する。

```text
誰が 誰に いくら渡すか
```

### 表示例

```text
第1ゲーム
A → B：20ポイント
C → D：20ポイント
```

### 注意

以下のようなプラス・マイナス表記は不要。

```text
A：-20
B：+20
```

ユーザーにとって見やすくするため、ゲームログは「支払い方向」と「金額」のみ表示する。

---

## Session 8：SettlementView 作成

ResultView の「精算する」を押した場合、SettlementView に遷移する。

SettlementView では以下を表示する。

1. 各ゲームの支払いログ
2. 最終精算結果
3. 初期化して最初から始めるためのボタン

---

## Session 9：ログ表示の色指定

ゲームログの表示色は以下にする。

### ユーザー名
- 黒色

### ポイント額
- 基本は黒色でよい
- プラス・マイナス表示はしない

例：

```text
A → B：20ポイント
```

A / B / 20ポイント は通常表示でよい。  
赤・緑のプラスマイナス表示は不要。

---

## Session 10：最終精算ロジック

SettlementView の最後に、全ゲームをまとめた最終的な支払い結果を表示する。

### 表示する内容

最終精算も、以下のみ表示する。

```text
最終的に誰が誰にいくら渡せばいいか
```

### 表示例

累計ポイントが以下の場合：

```text
A: +40
B: -20
C: -20
D: 0
```

表示する最終精算：

```text
B → A：20ポイント
C → A：20ポイント
```

### 注意

以下のような累計ポイント表示は必須ではない。

```text
A：+40
B：-20
C：-20
D：0
```

ユーザーに見せる最終結果は「誰が誰にいくら渡すか」を優先する。

---

## Session 11：精算後の初期化処理

SettlementView で精算を完了したら、全ての情報を初期化する。

### 初期化対象

- プレイヤー一覧
- プレイヤー名
- プレイヤー累計ポイント
- ゲームログ
- ゲーム回数
- 順位
- チーム選択
- ベースポイント
- 倍率イベント
- 計算結果
- 画面状態

### 初期化後の遷移

精算完了後は、最初の PortalView に戻る。

このとき、プレイヤー名も再入力できる状態に戻す。

---

## Session 12：データ構造の追加・修正

必要に応じて以下のようなモデルを追加する。

```swift
struct GameLog: Identifiable {
    let id = UUID()
    let gameNumber: Int
    let transactions: [PointTransaction]
}

struct PointTransaction: Identifiable {
    let id = UUID()
    let fromPlayerId: UUID
    let toPlayerId: UUID
    let point: Int
}
```

### 重要

PointTransaction は「支払い」を表す。  
そのため `point` は常に正の値として扱う。

```swift
point > 0
```

マイナス値はログには保存しない。

---

## Session 13：ViewModel / Calculator の責務

View にビジネスロジックを書かない。

### 責務分離

- View：表示のみ
- ViewModel：状態管理、画面遷移制御
- ScoreCalculator：1ゲームごとのポイント計算
- SettlementCalculator：最終精算計算
- GameLog：各ゲームの支払い履歴

---

## Session 14：完了条件

以下を満たしたら完了。

- ResultView のボタン名が「次のゲームへ」「精算する」になっている
- 「次のゲームへ」で PortalView に戻る
- 次ゲームでもプレイヤーと累計ポイントが維持される
- 2ゲーム目以降はプレイヤー名を変更できない
- 「精算する」で SettlementView に遷移する
- SettlementView に各ゲームの支払いログが表示される
- ゲームログは「誰 → 誰：ポイント」の形式で表示される
- ゲームログに + / - 表記を表示しない
- 最終精算も「誰 → 誰：ポイント」の形式で表示される
- 精算完了後、全情報が初期化される
- 精算完了後、最初の PortalView に戻り、プレイヤー名を再入力できる
