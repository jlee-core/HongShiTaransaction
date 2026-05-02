import Foundation
import Combine

@MainActor
final class TeamSelectionViewModel: ObservableObject {
    @Published var players: [Player]

    init(players: [Player]) {
        self.players = players.map {
            var player = $0
            player.teamColor = .none
            return player
        }
    }

    var isTeamSelectionCompleted: Bool {
        areAllPlayersSelected && isValidTeamBalance
    }

    var teamSelectionErrorMessage: String? {
        if !areAllPlayersSelected {
            return "全員のチームを選択してください"
        }
        if !isValidTeamBalance {
            return "チームは 2:2 または 1:3 になるように選択してください"
        }
        return nil
    }

    var isValidTeamBalance: Bool {
        let counts = teamCounts
        let redCount = counts[.red, default: 0]
        let blackCount = counts[.black, default: 0]
        return (redCount == 2 && blackCount == 2)
            || (redCount == 1 && blackCount == 3)
            || (redCount == 3 && blackCount == 1)
    }

    private var teamCounts: [TeamColor: Int] {
        Dictionary(grouping: players.map(\.teamColor), by: { $0 })
            .mapValues(\.count)
    }

    private var areAllPlayersSelected: Bool {
        players.allSatisfy { $0.teamColor != .none }
    }

    func toggleTeamColor(for player: Player) {
        guard let index = players.firstIndex(where: { $0.id == player.id }) else { return }
        players[index].teamColor = players[index].teamColor.nextSelection
    }
}
