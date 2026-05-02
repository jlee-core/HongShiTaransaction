import Foundation
import Combine

@MainActor
final class SetupViewModel: ObservableObject {
    @Published var players: [Player] = [
        Player(name: "PlayerA", point: 0),
        Player(name: "PlayerB", point: 0),
        Player(name: "PlayerC", point: 0),
        Player(name: "PlayerD", point: 0)
    ]
    @Published var basePointText = "0"
    @Published var scoreEvents = ScoreEventState()
    @Published var canEditPlayers = true

    var basePoint: Int {
        Int(basePointText) ?? 0
    }

    var finalBasePoint: Int {
        basePoint * (1 << scoreEvents.multiplierCount)
    }

    var canStart: Bool {
        players.count == 4
            && players.allSatisfy { !$0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            && basePoint > 0
    }

    var startErrorMessage: String? {
        if players.count < 4 {
            return "4人のプレイヤーを設定してください。"
        }
        if players.contains(where: { $0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) {
            return "プレイヤー名は空にできません。"
        }
        if basePoint <= 0 {
            return "ベースポイントは1以上を入力してください。"
        }
        return nil
    }

    func updatePlayerName(for player: Player, name: String) {
        guard canEditPlayers else { return }
        guard let index = players.firstIndex(where: { $0.id == player.id }) else { return }
        players[index].name = name
    }

    func prepareForNextGame(
        players: [Player],
        basePoint: Int,
        canEditPlayers: Bool
    ) {
        self.players = players.map {
            var player = $0
            player.rank = nil
            player.teamColor = .none
            return player
        }
        self.canEditPlayers = canEditPlayers
        basePointText = "\(basePoint)"
        scoreEvents = ScoreEventState()
    }
}
