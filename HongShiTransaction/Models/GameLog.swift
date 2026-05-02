import Foundation

struct GameTransaction: Identifiable, Equatable {
    let id = UUID()
    let payerName: String
    let receiverName: String
    let point: Int

    init(payerName: String, receiverName: String, point: Int) {
        self.payerName = payerName
        self.receiverName = receiverName
        self.point = abs(point)
    }
}

struct GameLog: Identifiable, Equatable {
    let id = UUID()
    let gameNumber: Int
    let basePoint: Int
    let finalBasePoint: Int
    let transactions: [GameTransaction]
}
