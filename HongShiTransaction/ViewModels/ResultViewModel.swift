import Foundation
import Combine

@MainActor
final class ResultViewModel: ObservableObject {
    @Published var result: GameResult

    init(result: GameResult) {
        self.result = result
    }

    var sortedPlayers: [Player] {
        result.players.sorted { ($0.rank ?? Int.max) < ($1.rank ?? Int.max) }
    }
}
