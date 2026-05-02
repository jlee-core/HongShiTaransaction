import SwiftUI

struct SurrenderPlayerSelectionView: View {
    @ObservedObject var viewModel: SurrenderPlayerSelectionViewModel
    let onSelectPlayer: (Player) -> Void
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            ForEach(viewModel.players, id: \.id) { player in
                Button {
                    onSelectPlayer(player)
                } label: {
                    HStack {
                        Text(player.name)
                            .font(.headline)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("降参プレイヤー")
        .toolbar {
            ToolbarItem {
                Button("戻る", action: onBack)
            }
        }
    }
}

struct SurrenderPlayerSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SurrenderPlayerSelectionView(
                viewModel: SurrenderPlayerSelectionViewModel(players: [
                    Player(name: "PlayerA"),
                    Player(name: "PlayerB"),
                    Player(name: "PlayerC"),
                    Player(name: "PlayerD")
                ]),
                onSelectPlayer: { _ in },
                onBack: {}
            )
        }
    }
}
