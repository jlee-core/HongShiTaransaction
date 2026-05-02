import Foundation
import Combine

@MainActor
final class RankingViewModel: ObservableObject {
    @Published var players: [Player]

    init(players: [Player]) {
        self.players = players.map {
            var player = $0
            player.rank = nil
            player.teamColor = .none
            return player
        }
    }

    var isRankingCompleted: Bool {
        players.allSatisfy { $0.rank != nil }
    }

    var nextRank: Int {
        players.compactMap(\.rank).count + 1
    }

    func selectPlayer(_ player: Player) {
        guard !isSelected(player) else { return }
        guard let index = players.firstIndex(where: { $0.id == player.id }) else { return }
        players[index].rank = nextRank
    }

    func reset() {
        players = players.map {
            var player = $0
            player.rank = nil
            return player
        }
    }

    func isSelected(_ player: Player) -> Bool {
        players.first(where: { $0.id == player.id })?.rank != nil
    }
}
