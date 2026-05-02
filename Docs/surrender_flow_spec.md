# 降参フロー修正仕様

## 目的
降参はゲーム開始前に行う処理のため、順位決定前に実行できるようフローを修正する。

---

## 問題点（現状）
現在：

PortalView → RankingView → TeamSelectionView → 降参

これは不正なフロー。

---

## 修正後フロー

PortalView
↓
GameStartOptionView
↓
RankingView または ResultView

---

## GameStartOptionView

### 表示内容

- チームを決める
- 降参

---

## チームを決める

→ RankingView に遷移（通常フロー）

---

## 降参

→ 降参プレイヤー選択画面へ遷移

---

## SurrenderPlayerSelectionView

### 表示

PlayerA  
PlayerB  
PlayerC  
PlayerD  

→ 1人選択

---

## 降参ロジック

### 使用値

- basePoint のみ使用
- 倍率は適用しない

---

## 支払いルール

降参者 → 他3人にそれぞれ支払い

### 例

basePoint = 20  
降参者 = PlayerA  

PlayerA → PlayerB：20  
PlayerA → PlayerC：20  
PlayerA → PlayerD：20  

---

## 遷移

SurrenderPlayerSelectionView  
↓  
ResultView  

---

## 制約

- 順位入力しない
- チーム選択しない
- 倍率使わない
- basePointのみ

---

## 実装対象

追加：
- GameStartOptionView
- SurrenderPlayerSelectionView

修正：
- PortalView
- ResultView
- ScoreCalculator
- ViewModel

---

## 完了条件

- 降参は順位前に実行される
- 降参時は倍率なし
- 降参者が他3人に支払う
- ResultViewに表示される
- GameLogに保存される
