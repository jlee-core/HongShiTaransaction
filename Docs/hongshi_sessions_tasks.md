# HongShiTransaction 実装タスク（Session分割）

## Session 1：UI文言と基本設定
- ResultView ボタン文言変更
  - 「精算する」→「次のゲームへ」
  - 「まとめて精算」→「精算する」
- ベースポイント初期値を0に変更

---

## Session 2：倍率イベント修正
- イベント名変更：
  - 亮牌 / 顶牌 / 踢 / 反踢
- 各イベントで×2倍率適用
- 最終計算：
  finalBasePoint = base × 2^n

---

## Session 3：PortalView 入力制御
- basePoint > 0 の場合のみ開始可能
- 無効時：
  - ボタンdisabled
  - エラーメッセージ表示

---

## Session 4：画面遷移変更
- 「次のゲームへ」→ PortalViewへ遷移
- RankingViewには戻らない

---

## Session 5：状態管理
維持：
- プレイヤー
- 累計ポイント

初期化：
- 順位
- チーム
- ベースポイント
- 倍率
- 今回結果

---

## Session 6：ユーザー編集制御
- 2ゲーム目以降は名前編集不可

---

## Session 7：ログ機能
- GameLog / Transaction モデル作成
- ゲーム毎の履歴保存

---

## Session 8：精算画面
- SettlementView作成
- 各ゲームログ表示
  - 第nゲーム
  - 誰→誰：ポイント

色：
- 名前：黒
- +：緑
- -：赤

---

## Session 9：最終精算ロジック
- 累計から最終支払い計算
- 誰→誰 を表示

---

## Session 10：責務分離
- View：表示のみ
- ViewModel：状態管理
- ScoreCalculator：ゲーム計算
- SettlementCalculator：最終精算

---

## 完了条件
- 全フロー動作
- ログ表示可能
- 最終精算表示可能
