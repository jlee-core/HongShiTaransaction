# チーム選択UI変更仕様

## 目的
チーム選択画面のUIを簡略化し、赤/黒の選択ボタンを削除する。  
プレイヤー名をクリックするだけで、赤チーム・黒チームを切り替えられるようにする。

---

## 対象画面
- TeamSelectionView
- チームを決める画面

---

## 変更前の仕様

現在の仕様は以下。

```text
1. 赤ボタンまたは黒ボタンを選択する
2. プレイヤー名をクリックする
3. 選択中の色がプレイヤーに割り当てられる
```

---

## 変更後の仕様

赤ボタン・黒ボタンを削除する。  
プレイヤー名をクリックすることで、そのプレイヤーのチーム色を toggle で切り替える。

---

## チーム色の状態

チーム色は以下の3状態を持つ。

```swift
enum TeamColor {
    case none
    case red
    case black
}
```

---

## 初期状態

画面表示時、全プレイヤーのチーム色は未選択状態にする。

```text
Player A：none
Player B：none
Player C：none
Player D：none
```

---

## toggle 仕様

プレイヤー名をクリックするたびに、以下の順番で色を切り替える。

```text
none → red → black → red → black ...
```

---

## クリック時の動作例

### 1回目クリック

```text
none → red
```

### 2回目クリック

```text
red → black
```

### 3回目クリック

```text
black → red
```

---

## ViewModel に実装する処理

View に直接ロジックを書かない。  
toggle 処理は ViewModel に実装する。

### 実装イメージ

```swift
func toggleTeamColor(for player: Player) {
    switch player.teamColor {
    case .none:
        player.teamColor = .red
    case .red:
        player.teamColor = .black
    case .black:
        player.teamColor = .red
    }
}
```

実際の実装では、Player が struct の場合は配列内の対象Playerを index で更新すること。

---

## 表示仕様

### 未選択

```text
通常表示
枠線なし、またはグレー枠
```

### 赤チーム

```text
赤い枠線
または赤系の背景色
```

### 黒チーム

```text
黒い枠線
または黒系の背景色
```

---

## UIから削除するもの

以下のUIは削除する。

```text
赤を選択するボタン
黒を選択するボタン
現在選択中の色を保持するUI状態
```

---

## バリデーション

次へ進む前に、全プレイヤーが赤または黒のどちらかに設定されていることを確認する。

### OK条件

```text
全プレイヤーの teamColor が red または black
```

### NG条件

```text
1人でも teamColor が none のプレイヤーがいる
```

NGの場合は次へ進めないようにする。

---

## チーム人数の制御

MVPでは以下の2パターンを許可する。

```text
2:2
1:3
```

### OK例

```text
赤2人 / 黒2人
赤1人 / 黒3人
赤3人 / 黒1人
```

### NG例

```text
赤4人 / 黒0人
赤0人 / 黒4人
```

---

## エラーメッセージ例

未選択プレイヤーがいる場合：

```text
全員のチームを選択してください
```

チーム人数が不正な場合：

```text
チームは 2:2 または 1:3 になるように選択してください
```

---

## 完了条件

以下を満たしたら完了。

- 赤/黒の選択ボタンが削除されている
- プレイヤー名クリックだけでチーム色を変更できる
- 初期状態は全員 none
- 1回目クリックで red になる
- 2回目クリックで black になる
- 3回目クリックで red に戻る
- 全員が red または black になるまで次へ進めない
- チーム人数が 2:2 または 1:3 以外の場合は次へ進めない
- toggle 処理は ViewModel に実装されている
- View にビジネスロジックを書かない
