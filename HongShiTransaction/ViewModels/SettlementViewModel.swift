import Foundation
import Combine

@MainActor
final class SettlementViewModel: ObservableObject {
    @Published var gameLogs: [GameLog]
    @Published var finalTransactions: [GameTransaction]

    init(
        gameLogs: [GameLog],
        finalTransactions: [GameTransaction]
    ) {
        self.gameLogs = gameLogs
        self.finalTransactions = finalTransactions
    }
}
