import Foundation

final class SettlementCalculator {
    func calculateFinalTransactions(players: [Player]) -> [GameTransaction] {
        var debtors = players
            .filter { $0.point < 0 }
            .map { (name: $0.name, amount: abs($0.point)) }
            .sorted { $0.amount > $1.amount }

        var creditors = players
            .filter { $0.point > 0 }
            .map { (name: $0.name, amount: $0.point) }
            .sorted { $0.amount > $1.amount }

        var transactions: [GameTransaction] = []
        var debtorIndex = 0
        var creditorIndex = 0

        while debtorIndex < debtors.count && creditorIndex < creditors.count {
            let point = min(debtors[debtorIndex].amount, creditors[creditorIndex].amount)
            transactions.append(
                GameTransaction(
                    payerName: debtors[debtorIndex].name,
                    receiverName: creditors[creditorIndex].name,
                    point: point
                )
            )

            debtors[debtorIndex].amount -= point
            creditors[creditorIndex].amount -= point

            if debtors[debtorIndex].amount == 0 {
                debtorIndex += 1
            }
            if creditors[creditorIndex].amount == 0 {
                creditorIndex += 1
            }
        }

        return transactions
    }
}
