import SwiftUI

struct TeamSelectionView: View {
    @ObservedObject var viewModel: TeamSelectionViewModel
    let onNext: () -> Void
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            VStack(spacing: 12) {
                ForEach(viewModel.players.sorted { ($0.rank ?? Int.max) < ($1.rank ?? Int.max) }, id: \.id) { player in
                    Button {
                        viewModel.toggleTeamColor(for: player)
                    } label: {
                        HStack {
                            Text("\(player.rank ?? 0)位")
                                .font(.headline)
                                .frame(width: 44, alignment: .leading)
                            Text(player.name)
                            Spacer()
                            Text(player.teamColor.title)
                                .foregroundStyle(player.teamColor.displayColor)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.thinMaterial)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    player.teamColor.borderColor,
                                    style: StrokeStyle(lineWidth: 2, dash: [6, 4])
                                )
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                }
            }

            if let message = viewModel.teamSelectionErrorMessage {
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer()

            Button("次へ", action: onNext)
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .disabled(!viewModel.isTeamSelectionCompleted)
        }
        .padding()
        .navigationTitle("チームを決める")
        .toolbar {
            ToolbarItem {
                Button("順位", action: onBack)
            }
        }
    }
}

struct TeamSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TeamSelectionView(
                viewModel: TeamSelectionViewModel(players: [
                    Player(name: "A", rank: 1),
                    Player(name: "B", rank: 2),
                    Player(name: "C", rank: 3),
                    Player(name: "D", rank: 4)
                ]),
                onNext: {},
                onBack: {}
            )
        }
    }
}
