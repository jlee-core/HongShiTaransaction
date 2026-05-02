import Foundation

struct SettlementEntry: Identifiable, Equatable {
    let id = UUID()
    let payerName: String
    let receiverName: String
    let point: Int
}

struct GameResult: Equatable {
    var players: [Player]
    var basePoint: Int
    var finalBasePoint: Int
    var settlementEntries: [SettlementEntry]
    var message: String
}
