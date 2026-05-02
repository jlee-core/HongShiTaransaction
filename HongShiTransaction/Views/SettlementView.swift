import SwiftUI

struct SettlementView: View {
    @ObservedObject var viewModel: SettlementViewModel
    let onCompleteSettlement: () -> Void

    var body: some View {
        List {
            Section("ゲームログ") {
                if viewModel.gameLogs.isEmpty {
                    Text("ログはありません。")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.gameLogs, id: \.id) { log in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("第\(log.gameNumber)ゲーム")
                                .font(.headline)

                            if log.transactions.isEmpty {
                                Text("支払いなし")
                                    .foregroundStyle(.secondary)
                            } else {
                                ForEach(log.transactions, id: \.id) { transaction in
                                    TransactionLine(transaction: transaction)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }

            Section("最終精算") {
                if viewModel.finalTransactions.isEmpty {
                    Text("最終支払いはありません。")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.finalTransactions, id: \.id) { transaction in
                        TransactionLine(transaction: transaction)
                    }
                }
            }

            Section {
                Button("精算を完了して最初から始める", action: onCompleteSettlement)
            }
        }
        .navigationTitle("精算")
    }
}

private struct TransactionLine: View {
    let transaction: GameTransaction

    var body: some View {
        HStack {
            Text(transaction.payerName)
                .foregroundStyle(Color.primary)
            Image(systemName: "arrow.right")
                .foregroundStyle(.secondary)
            Text(transaction.receiverName)
                .foregroundStyle(Color.primary)
            Spacer()
            Text("\(transaction.point)ポイント")
                .foregroundStyle(Color.primary)
        }
    }
}

struct SettlementView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettlementView(
                viewModel: SettlementViewModel(
                    gameLogs: [
                        GameLog(
                            gameNumber: 1,
                            basePoint: 20,
                            finalBasePoint: 40,
                            transactions: [
                                GameTransaction(payerName: "B", receiverName: "A", point: 40)
                            ]
                        )
                    ],
                    finalTransactions: [
                        GameTransaction(payerName: "B", receiverName: "A", point: 40)
                    ]
                ),
                onCompleteSettlement: {}
            )
        }
    }
}
