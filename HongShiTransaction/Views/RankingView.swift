import SwiftUI

struct RankingView: View {
    @ObservedObject var viewModel: RankingViewModel
    let onNext: () -> Void
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("タップした順に順位が決まります")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 12) {
                ForEach(viewModel.players, id: \.id) { player in
                    Button {
                        viewModel.selectPlayer(player)
                    } label: {
                        HStack {
                            Text(player.name)
                            Spacer()
                            if let rank = player.rank {
                                Text("\(rank)位")
                                    .font(.headline)
                            } else {
                                Text("未選択")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.isSelected(player))
                }
            }

            Spacer()

            Button("チームを決める", action: onNext)
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .disabled(!viewModel.isRankingCompleted)
        }
        .padding()
        .navigationTitle("順位")
        .toolbar {
            ToolbarItem {
                Button("設定", action: onBack)
            }

            ToolbarItem {
                Button("リセット", action: viewModel.reset)
            }
        }
    }
}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RankingView(
                viewModel: RankingViewModel(players: [
                    Player(name: "A"),
                    Player(name: "B"),
                    Player(name: "C"),
                    Player(name: "D")
                ]),
                onNext: {},
                onBack: {}
            )
        }
    }
}
