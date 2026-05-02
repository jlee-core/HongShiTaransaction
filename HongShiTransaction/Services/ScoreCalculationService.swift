import Foundation

final class ScoreCalculationService {
    func calculate(
        players: [Player],
        basePoint: Int,
        scoreEvents: ScoreEventState
    ) -> GameResult {
        let finalBasePoint = basePoint * (1 << scoreEvents.multiplierCount)
        let rankedPlayers = players.sorted { ($0.rank ?? Int.max) < ($1.rank ?? Int.max) }

        let entries: [SettlementEntry]
        let message: String

        if isOneAgainstThree(players: rankedPlayers) {
            let result = calculateOneAgainstThree(players: rankedPlayers, finalBasePoint: finalBasePoint)
            entries = result.entries
            message = result.message
        } else {
            let result = calculateTwoAgainstTwo(players: rankedPlayers, finalBasePoint: finalBasePoint)
            entries = result.entries
            message = result.message
        }

        return GameResult(
            players: apply(entries: entries, to: players),
            basePoint: basePoint,
            finalBasePoint: finalBasePoint,
            settlementEntries: entries,
            message: message
        )
    }

    func calculateSurrender(
        players: [Player],
        surrenderingPlayer: Player,
        basePoint: Int
    ) -> GameResult {
        let preparedPlayers = players.map {
            var player = $0
            player.rank = nil
            player.teamColor = .none
            return player
        }
        let entries = preparedPlayers
            .filter { $0.id != surrenderingPlayer.id }
            .map { opponent in
                SettlementEntry(
                    payerName: surrenderingPlayer.name,
                    receiverName: opponent.name,
                    point: basePoint
                )
            }

        return GameResult(
            players: apply(entries: entries, to: preparedPlayers),
            basePoint: basePoint,
            finalBasePoint: basePoint,
            settlementEntries: entries,
            message: "\(surrenderingPlayer.name)が降参しました。"
        )
    }

    private func calculateTwoAgainstTwo(
        players: [Player],
        finalBasePoint: Int
    ) -> (entries: [SettlementEntry], message: String) {
        let rankScores = [1: 3, 2: 1, 3: -1, 4: -3]
        let teamScores = Dictionary(grouping: players, by: { $0.teamColor })
            .mapValues { teamPlayers in
                teamPlayers.reduce(0) { total, player in
                    total + (rankScores[player.rank ?? 0] ?? 0)
                }
            }

        let redScore = teamScores[.red] ?? 0
        let blackScore = teamScores[.black] ?? 0

        guard redScore != blackScore else {
            return ([], "引き分けです。ポイント変動はありません。")
        }

        let winningColor: TeamColor = redScore > blackScore ? .red : .black
        let losingColor: TeamColor = winningColor == .red ? .black : .red
        let winners = players
            .filter { $0.teamColor == winningColor }
            .sorted { ($0.rank ?? Int.max) < ($1.rank ?? Int.max) }
        let losers = players
            .filter { $0.teamColor == losingColor }
            .sorted { ($0.rank ?? Int.max) < ($1.rank ?? Int.max) }

        let entries = zip(losers, winners).map { loser, winner in
            SettlementEntry(
                payerName: loser.name,
                receiverName: winner.name,
                point: finalBasePoint
            )
        }

        return (entries, "\(winningColor.title)チームの勝ちです。")
    }

    private func calculateOneAgainstThree(
        players: [Player],
        finalBasePoint: Int
    ) -> (entries: [SettlementEntry], message: String) {
        guard let single = singleTeamPlayer(from: players) else {
            return ([], "チーム構成を確認してください。")
        }

        let opponents = players.filter { $0.id != single.id }
        let singleRank = single.rank ?? Int.max

        switch singleRank {
        case 1:
            return (
                opponents.map { opponent in
                    SettlementEntry(payerName: opponent.name, receiverName: single.name, point: finalBasePoint)
                },
                "\(single.name)の一人勝ちです。"
            )
        case 2:
            return ([], "一人チームが2位のため引き分けです。")
        case 3:
            let topTwo = opponents.filter { ($0.rank ?? Int.max) <= 2 }
            let fourth = opponents.first { $0.rank == 4 }
            var entries = topTwo.map { winner in
                SettlementEntry(payerName: single.name, receiverName: winner.name, point: finalBasePoint)
            }
            if let fourth {
                entries.append(SettlementEntry(payerName: fourth.name, receiverName: single.name, point: finalBasePoint))
            }
            return (entries, "\(single.name)が3位の精算です。")
        case 4:
            return (
                opponents.map { opponent in
                    SettlementEntry(payerName: single.name, receiverName: opponent.name, point: finalBasePoint)
                },
                "\(single.name)が4位のため相手3人へ支払います。"
            )
        default:
            return ([], "順位を確認してください。")
        }
    }

    private func isOneAgainstThree(players: [Player]) -> Bool {
        Dictionary(grouping: players.filter { $0.teamColor != .none }, by: { $0.teamColor })
            .values
            .contains { $0.count == 1 }
    }

    private func singleTeamPlayer(from players: [Player]) -> Player? {
        Dictionary(grouping: players.filter { $0.teamColor != .none }, by: { $0.teamColor })
            .values
            .first { $0.count == 1 }?
            .first
    }

    private func apply(entries: [SettlementEntry], to players: [Player]) -> [Player] {
        players.map { player in
            var updated = player
            for entry in entries {
                if entry.payerName == player.name {
                    updated.point -= entry.point
                }
                if entry.receiverName == player.name {
                    updated.point += entry.point
                }
            }
            return updated
        }
    }
}
