import Foundation
import Combine

@MainActor
final class GameFlowViewModel: ObservableObject {
    enum Screen {
        case setup
        case gameStartOption
        case ranking
        case surrenderPlayerSelection
        case teamSelection
        case result
        case settlement
    }

    @Published var screen: Screen = .setup
    @Published var setupViewModel = SetupViewModel()
    @Published var rankingViewModel: RankingViewModel?
    @Published var surrenderPlayerSelectionViewModel: SurrenderPlayerSelectionViewModel?
    @Published var teamSelectionViewModel: TeamSelectionViewModel?
    @Published var resultViewModel: ResultViewModel?
    @Published var settlementViewModel: SettlementViewModel?

    private let scoreCalculationService = ScoreCalculationService()
    private let settlementCalculator = SettlementCalculator()
    private var basePoint = 0
    private var scoreEvents = ScoreEventState()
    private var gameLogs: [GameLog] = []

    func startGame() {
        guard setupViewModel.canStart else { return }
        basePoint = setupViewModel.basePoint
        scoreEvents = setupViewModel.scoreEvents
        screen = .gameStartOption
    }

    func startNormalGame() {
        rankingViewModel = RankingViewModel(players: setupViewModel.players)
        screen = .ranking
    }

    func startSurrenderFlow() {
        surrenderPlayerSelectionViewModel = SurrenderPlayerSelectionViewModel(players: setupViewModel.players)
        screen = .surrenderPlayerSelection
    }

    func showSurrenderResult(for player: Player) {
        guard let surrenderPlayerSelectionViewModel else { return }
        let result = scoreCalculationService.calculateSurrender(
            players: surrenderPlayerSelectionViewModel.players,
            surrenderingPlayer: player,
            basePoint: basePoint
        )
        save(result: result)
        screen = .result
    }

    func showTeamSelection() {
        guard let rankingViewModel, rankingViewModel.isRankingCompleted else { return }
        teamSelectionViewModel = TeamSelectionViewModel(players: rankingViewModel.players)
        screen = .teamSelection
    }

    func showResult() {
        guard let teamSelectionViewModel, teamSelectionViewModel.isTeamSelectionCompleted else { return }
        let result = scoreCalculationService.calculate(
            players: teamSelectionViewModel.players,
            basePoint: basePoint,
            scoreEvents: scoreEvents
        )
        save(result: result)
        screen = .result
    }

    private func save(result: GameResult) {
        resultViewModel = ResultViewModel(result: result)
        setupViewModel.players = result.players
        gameLogs.append(
            GameLog(
                gameNumber: gameLogs.count + 1,
                basePoint: result.basePoint,
                finalBasePoint: result.finalBasePoint,
                transactions: result.settlementEntries.map {
                    GameTransaction(
                        payerName: $0.payerName,
                        receiverName: $0.receiverName,
                        point: $0.point
                    )
                }
            )
        )
    }

    func nextGame() {
        let previousBasePoint = basePoint
        let nextPlayers = setupViewModel.players.map {
            var player = $0
            player.rank = nil
            player.teamColor = .none
            return player
        }
        setupViewModel.prepareForNextGame(
            players: nextPlayers,
            basePoint: previousBasePoint,
            canEditPlayers: gameLogs.isEmpty
        )
        clearCurrentGameState()
        screen = .setup
    }

    func completeSettlement() {
        setupViewModel = SetupViewModel()
        gameLogs = []
        clearCurrentGameState()
        screen = .setup
    }

    func showSettlement() {
        settlementViewModel = SettlementViewModel(
            gameLogs: gameLogs,
            finalTransactions: settlementCalculator.calculateFinalTransactions(players: setupViewModel.players)
        )
        screen = .settlement
    }

    func backToSetup() {
        screen = .setup
    }

    private func clearCurrentGameState() {
        rankingViewModel = nil
        surrenderPlayerSelectionViewModel = nil
        teamSelectionViewModel = nil
        resultViewModel = nil
        settlementViewModel = nil
        basePoint = 0
        scoreEvents = ScoreEventState()
    }
}
