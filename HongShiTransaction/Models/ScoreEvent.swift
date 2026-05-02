import Foundation

struct ScoreEventState: Equatable {
    var isRevealEnabled = false
    var isTopEnabled = false
    var isKickEnabled = false
    var isReverseKickEnabled = false

    var multiplierCount: Int {
        [
            isRevealEnabled,
            isTopEnabled,
            isKickEnabled,
            isReverseKickEnabled
        ].filter { $0 }.count
    }
}
