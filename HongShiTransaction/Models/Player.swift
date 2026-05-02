import Foundation

struct Player: Identifiable, Equatable {
    let id: UUID
    var name: String
    var point: Int
    var rank: Int?
    var teamColor: TeamColor

    init(
        id: UUID = UUID(),
        name: String,
        point: Int = 0,
        rank: Int? = nil,
        teamColor: TeamColor = .none
    ) {
        self.id = id
        self.name = name
        self.point = point
        self.rank = rank
        self.teamColor = teamColor
    }
}
