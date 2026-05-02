# HongShiTransaction 計算ロジック用 Mock データ仕様

## 目的
ScoreCalculator / SettlementCalculator の計算ロジックをテストするためのMockデータを定義する。  
各テストケースでは、以下を必ず出力する。

- 前提条件
- プレイヤー
- ベースポイント
- 倍率イベント
- 最終ベースポイント
- 順位
- チーム構成
- 計算結果
- 支払いログ

---

# 共通プレイヤー

```text
Player A
Player B
Player C
Player D
```

---

# 倍率イベント

倍率イベントは以下の4つ。

```text
亮牌
顶牌
踢
反踢
```

選択されたイベント1つにつき、ベースポイントを2倍にする。

```text
finalBasePoint = basePoint × 2^eventCount
```

---

# Test Case 1：2:2 赤チーム勝利・倍率なし

## 前提条件

```text
basePoint = 20
倍率イベントなし
finalBasePoint = 20
```

## チーム

```text
赤チーム：Player A, Player C
黒チーム：Player B, Player D
```

## 順位

```text
1位：Player A（赤）
2位：Player B（黒）
3位：Player C（赤）
4位：Player D（黒）
```

## チームポイント

```text
赤：+3 + -1 = 2
黒：+1 + -3 = -2
```

## 勝敗

```text
赤チーム勝利
黒チーム敗北
```

## 支払いログ

```text
Player B → Player A：20ポイント
Player D → Player C：20ポイント
```

## 個人ポイント変動

```text
Player A：+20
Player B：-20
Player C：+20
Player D：-20
```

---

# Test Case 2：2:2 赤チーム勝利・勝ちチームが1位2位

## 前提条件

```text
basePoint = 20
倍率イベントなし
finalBasePoint = 20
```

## チーム

```text
赤チーム：Player A, Player B
黒チーム：Player C, Player D
```

## 順位

```text
1位：Player A（赤）
2位：Player B（赤）
3位：Player C（黒）
4位：Player D（黒）
```

## チームポイント

```text
赤：+3 + +1 = 4
黒：-1 + -3 = -4
```

## 勝敗

```text
赤チーム勝利
黒チーム敗北
```

## 支払いログ

```text
Player C → Player A：20ポイント
Player D → Player B：20ポイント
```

## 個人ポイント変動

```text
Player A：+20
Player B：+20
Player C：-20
Player D：-20
```

---

# Test Case 3：2:2 同点

## 前提条件

```text
basePoint = 20
倍率イベントなし
finalBasePoint = 20
```

## チーム

```text
赤チーム：Player A, Player D
黒チーム：Player B, Player C
```

## 順位

```text
1位：Player A（赤）
2位：Player B（黒）
3位：Player C（黒）
4位：Player D（赤）
```

## チームポイント

```text
赤：+3 + -3 = 0
黒：+1 + -1 = 0
```

## 勝敗

```text
同点
```

## 支払いログ

```text
なし
```

## 個人ポイント変動

```text
Player A：0
Player B：0
Player C：0
Player D：0
```

---

# Test Case 4：2:2 倍率すべて適用

## 前提条件

```text
basePoint = 20
亮牌 = true
顶牌 = true
踢 = true
反踢 = true
finalBasePoint = 20 × 2 × 2 × 2 × 2 = 320
```

## チーム

```text
赤チーム：Player A, Player C
黒チーム：Player B, Player D
```

## 順位

```text
1位：Player A（赤）
2位：Player B（黒）
3位：Player C（赤）
4位：Player D（黒）
```

## チームポイント

```text
赤：+3 + -1 = 2
黒：+1 + -3 = -2
```

## 勝敗

```text
赤チーム勝利
黒チーム敗北
```

## 支払いログ

```text
Player B → Player A：320ポイント
Player D → Player C：320ポイント
```

## 個人ポイント変動

```text
Player A：+320
Player B：-320
Player C：+320
Player D：-320
```

---

# Test Case 5：1:3 一人チームが1位

## 前提条件

```text
basePoint = 20
倍率イベントなし
finalBasePoint = 20
```

## チーム

```text
一人チーム：Player A
三人チーム：Player B, Player C, Player D
```

## 順位

```text
1位：Player A
2位：Player B
3位：Player C
4位：Player D
```

## 勝敗/精算ルール

```text
一人チームが1位
2位・3位・4位が一人チームに支払う
```

## 支払いログ

```text
Player B → Player A：20ポイント
Player C → Player A：20ポイント
Player D → Player A：20ポイント
```

## 個人ポイント変動

```text
Player A：+60
Player B：-20
Player C：-20
Player D：-20
```

---

# Test Case 6：1:3 一人チームが2位

## 前提条件

```text
basePoint = 20
倍率イベントなし
finalBasePoint = 20
```

## チーム

```text
一人チーム：Player A
三人チーム：Player B, Player C, Player D
```

## 順位

```text
1位：Player B
2位：Player A
3位：Player C
4位：Player D
```

## 勝敗/精算ルール

```text
一人チームが2位
平局
```

## 支払いログ

```text
なし
```

## 個人ポイント変動

```text
Player A：0
Player B：0
Player C：0
Player D：0
```

---

# Test Case 7：1:3 一人チームが3位

## 前提条件

```text
basePoint = 20
倍率イベントなし
finalBasePoint = 20
```

## チーム

```text
一人チーム：Player A
三人チーム：Player B, Player C, Player D
```

## 順位

```text
1位：Player B
2位：Player C
3位：Player A
4位：Player D
```

## 勝敗/精算ルール

```text
一人チームが1位・2位に支払う
4位が一人チームに支払う
```

## 支払いログ

```text
Player A → Player B：20ポイント
Player A → Player C：20ポイント
Player D → Player A：20ポイント
```

## 個人ポイント変動

```text
Player A：-20
Player B：+20
Player C：+20
Player D：-20
```

---

# Test Case 8：1:3 一人チームが4位

## 前提条件

```text
basePoint = 20
倍率イベントなし
finalBasePoint = 20
```

## チーム

```text
一人チーム：Player A
三人チーム：Player B, Player C, Player D
```

## 順位

```text
1位：Player B
2位：Player C
3位：Player D
4位：Player A
```

## 勝敗/精算ルール

```text
一人チームが1位・2位・3位に支払う
```

## 支払いログ

```text
Player A → Player B：20ポイント
Player A → Player C：20ポイント
Player A → Player D：20ポイント
```

## 個人ポイント変動

```text
Player A：-60
Player B：+20
Player C：+20
Player D：+20
```

---

# Test Case 9：1:3 降参

## 前提条件

```text
basePoint = 20
亮牌 = true
finalBasePoint = 40
ゲーム開始前に一人チームが降参
```

## チーム

```text
一人チーム：Player A
三人チーム：Player B, Player C, Player D
```

## 支払いログ

```text
Player A → Player B：40ポイント
Player A → Player C：40ポイント
Player A → Player D：40ポイント
```

## 個人ポイント変動

```text
Player A：-120
Player B：+40
Player C：+40
Player D：+40
```

---

# Test Case 10：複数ゲーム後の最終精算

## 前提条件

3ゲーム行ったものとする。

---

## 第1ゲーム

```text
Player B → Player A：20ポイント
Player D → Player C：20ポイント
```

### 累計変動

```text
Player A：+20
Player B：-20
Player C：+20
Player D：-20
```

---

## 第2ゲーム

```text
Player A → Player B：20ポイント
Player A → Player C：20ポイント
Player D → Player A：20ポイント
```

### 累計変動

```text
Player A：-20
Player B：+20
Player C：+20
Player D：-20
```

---

## 第3ゲーム

```text
Player A → Player B：40ポイント
Player A → Player C：40ポイント
Player A → Player D：40ポイント
```

### 累計変動

```text
Player A：-120
Player B：+40
Player C：+40
Player D：+40
```

---

## 全ゲーム累計

```text
Player A：-120
Player B：+40
Player C：+80
Player D：0
```

---

## 最終精算結果

最終的に誰が誰にいくら渡せばいいかのみ表示する。

```text
Player A → Player C：80ポイント
Player A → Player B：40ポイント
```

---

# Codex 実装指示

## 出力用デバッグ関数

テスト時に、各ゲームの計算結果をコンソールまたは画面に出力できるようにする。

### 出力内容

```text
【前提条件】
basePoint:
倍率イベント:
finalBasePoint:
チーム:
順位:

【支払いログ】
A → B：xxポイント

【個人ポイント変動】
A：+xx
B：-xx
C：0

【最終精算】
A → B：xxポイント
```

---

## 注意

- ゲームログ画面では `+ / -` 表記は不要
- デバッグ出力では検証しやすいように `+ / -` 表記を出してよい
- PointTransaction の point は常に正の値
- 支払い方向は from → to で表す
