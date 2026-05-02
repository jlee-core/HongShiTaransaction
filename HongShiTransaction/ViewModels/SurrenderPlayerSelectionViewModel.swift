import Foundation
import Combine

@MainActor
final class SurrenderPlayerSelectionViewModel: ObservableObject {
    @Published var players: [Player]

    init(players: [Player]) {
        self.players = players.map {
            var player = $0
            player.rank = nil
            player.teamColor = .none
            return player
        }
    }
}
