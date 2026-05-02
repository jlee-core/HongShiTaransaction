import SwiftUI

struct ResultView: View {
    @ObservedObject var viewModel: ResultViewModel
    let onNextGame: () -> Void
    let onSettlement: () -> Void

    var body: some View {
        List {
            Section("計算") {
                LabeledContent("ベースポイント", value: "\(viewModel.result.basePoint) pt")
                LabeledContent("最終ベースポイント", value: "\(viewModel.result.finalBasePoint) pt")
                Text(viewModel.result.message)
            }

            Section("プレイヤーポイント") {
                ForEach(viewModel.sortedPlayers, id: \.id) { player in
                    PlayerResultRow(player: player)
                }
            }

            Section("支払い") {
                if viewModel.result.settlementEntries.isEmpty {
                    Text("支払いはありません。")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.result.settlementEntries) { entry in
                        HStack {
                            Text(entry.payerName)
                            Image(systemName: "arrow.right")
                                .foregroundStyle(.secondary)
                            Text(entry.receiverName)
                            Spacer()
                            Text("\(entry.point) pt")
                        }
                    }
                }
            }

            Section {
                Button("次のゲームへ", action: onNextGame)
                Button("精算する", action: onSettlement)
            }
        }
        .navigationTitle("結果")
    }
}

private struct PlayerResultRow: View {
    let player: Player

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(player.name)
                    .font(.headline)
                Text("\(player.rank ?? 0)位 / \(player.teamColor.title)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(player.point) pt")
                .font(.headline)
                .foregroundStyle(player.point >= 0 ? Color.primary : Color.red)
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ResultView(
                viewModel: ResultViewModel(
                    result: GameResult(
                        players: [
                            Player(name: "A", point: 20, rank: 1, teamColor: .red),
                            Player(name: "B", point: -20, rank: 2, teamColor: .black)
                        ],
                        basePoint: 20,
                        finalBasePoint: 20,
                        settlementEntries: [
                            SettlementEntry(payerName: "B", receiverName: "A", point: 20)
                        ],
                        message: "赤チームの勝ちです。"
                    )
                ),
            onNextGame: {},
            onSettlement: {}
        )
    }
}
}
