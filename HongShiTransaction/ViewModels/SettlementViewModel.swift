import Foundation
import Combine

@MainActor
final class SettlementViewModel: ObservableObject {
    @Published var gameLogs: [GameLog]
    @Published var players: [Player]
    @Published var finalTransactions: [GameTransaction]

    init(
        gameLogs: [GameLog],
        players: [Player],
        finalTransactions: [GameTransaction]
    ) {
        self.gameLogs = gameLogs
        self.players = players
        self.finalTransactions = finalTransactions
    }

    var sortedPlayers: [Player] {
        players.sorted { $0.name < $1.name }
    }
}
