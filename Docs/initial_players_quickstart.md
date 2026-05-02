# 初期ユーザー（クイックスタート）仕様

## 目的
毎回プレイヤーを作成する手間を省き、アプリ起動後すぐにゲームを開始できるようにする。

---

## 初期ユーザー設定

アプリ起動時、以下の4人のプレイヤーを自動生成する。

PlayerA  
PlayerB  
PlayerC  
PlayerD  

---

## 初期状態

各プレイヤーの状態：

- 名前：PlayerA〜D
- ポイント：0
- チーム：未選択

---

## 実装仕様

### ViewModel 初期化

```swift
players = [
    Player(name: "PlayerA", point: 0),
    Player(name: "PlayerB", point: 0),
    Player(name: "PlayerC", point: 0),
    Player(name: "PlayerD", point: 0)
]
```

---

## ユーザー名編集仕様

### 操作方法

- プレイヤー名をクリックすると編集可能

---

## UI仕様

### 通常表示
Text(player.name)

### 編集時
TextField に切り替える

---

## 動作フロー

1. 名前をタップ
2. TextFieldに切替
3. 編集
4. フォーカス外で確定

---

## 実装例

```swift
@State var editingPlayerId: UUID?

if editingPlayerId == player.id {
    TextField("", text: $player.name)
} else {
    Text(player.name)
        .onTapGesture {
            editingPlayerId = player.id
        }
}
```

---

## バリデーション

- 空文字不可
- 同名は許可（MVP）

---

## 次ゲーム時

- プレイヤー名維持

---

## 精算後

- 初期状態に戻す

PlayerA  
PlayerB  
PlayerC  
PlayerD  

---

## 完了条件

- 起動時4人生成
- 名前表示される
- タップで編集可能
- 編集反映される
- 次ゲームでも維持
- 精算後リセット
