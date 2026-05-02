//
//  PortalView.swift
//  HongShiTransaction
//
//  Created by j.lee on 2026/05/02.
//

import SwiftUI

struct PortalView: View {
    @StateObject private var viewModel = GameFlowViewModel()

    var body: some View {
        NavigationStack {
            switch viewModel.screen {
            case .setup:
                SetupView(
                    viewModel: viewModel.setupViewModel,
                    onStart: viewModel.startGame
                )
            case .gameStartOption:
                GameStartOptionView(
                    onNormalGame: viewModel.startNormalGame,
                    onSurrender: viewModel.startSurrenderFlow,
                    onBack: viewModel.backToSetup
                )
            case .ranking:
                if let rankingViewModel = viewModel.rankingViewModel {
                    RankingView(
                        viewModel: rankingViewModel,
                        onNext: viewModel.showTeamSelection,
                        onBack: viewModel.backToSetup
                    )
                }
            case .surrenderPlayerSelection:
                if let surrenderPlayerSelectionViewModel = viewModel.surrenderPlayerSelectionViewModel {
                    SurrenderPlayerSelectionView(
                        viewModel: surrenderPlayerSelectionViewModel,
                        onSelectPlayer: viewModel.showSurrenderResult,
                        onBack: {
                            viewModel.screen = .gameStartOption
                        }
                    )
                }
            case .teamSelection:
                if let teamSelectionViewModel = viewModel.teamSelectionViewModel {
                    TeamSelectionView(
                        viewModel: teamSelectionViewModel,
                        onNext: viewModel.showResult,
                        onBack: {
                            viewModel.screen = .ranking
                        }
                    )
                }
            case .result:
                if let resultViewModel = viewModel.resultViewModel {
                    ResultView(
                        viewModel: resultViewModel,
                        onNextGame: viewModel.nextGame,
                        onSettlement: viewModel.showSettlement
                    )
                }
            case .settlement:
                if let settlementViewModel = viewModel.settlementViewModel {
                    SettlementView(
                        viewModel: settlementViewModel,
                        onCompleteSettlement: viewModel.completeSettlement
                    )
                }
            }
        }
    }
}

struct PortalView_Previews: PreviewProvider {
    static var previews: some View {
        PortalView()
    }
}
