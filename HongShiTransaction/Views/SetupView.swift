import SwiftUI

struct SetupView: View {
    @ObservedObject var viewModel: SetupViewModel
    let onStart: () -> Void
    @State private var editingPlayerId: UUID?

    var body: some View {
        Form {
            Section("プレイヤー") {
                ForEach(viewModel.players, id: \.id) { player in
                    EditablePlayerRow(
                        player: player,
                        isEditing: editingPlayerId == player.id,
                        canEdit: viewModel.canEditPlayers,
                        onStartEditing: {
                            editingPlayerId = player.id
                        },
                        onFinishEditing: {
                            editingPlayerId = nil
                        },
                        name: Binding(
                            get: {
                                viewModel.players.first(where: { $0.id == player.id })?.name ?? player.name
                            },
                            set: { viewModel.updatePlayerName(for: player, name: $0) }
                        )
                    )
                }

                if !viewModel.canEditPlayers {
                    Text("2ゲーム目以降はプレイヤー名を維持します。")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Section("ベースポイント") {
                TextField("20", text: $viewModel.basePointText)
            }

            Section("倍率イベント") {
                Toggle("亮牌", isOn: $viewModel.scoreEvents.isRevealEnabled)
                Toggle("顶牌", isOn: $viewModel.scoreEvents.isTopEnabled)
                Toggle("踢", isOn: $viewModel.scoreEvents.isKickEnabled)
                Toggle("反踢", isOn: $viewModel.scoreEvents.isReverseKickEnabled)

                LabeledContent("最終ベースポイント") {
                    Text("\(viewModel.finalBasePoint) pt")
                }
            }

            Section {
                Button("スタート", action: onStart)
                    .frame(maxWidth: .infinity)
                    .disabled(!viewModel.canStart)
            } footer: {
                if let message = viewModel.startErrorMessage {
                    Text(message)
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("红十 精算")
    }
}

private struct EditablePlayerRow: View {
    let player: Player
    let isEditing: Bool
    let canEdit: Bool
    let onStartEditing: () -> Void
    let onFinishEditing: () -> Void
    @Binding var name: String
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        HStack {
            if isEditing {
                TextField("", text: $name)
                    .autocorrectionDisabled()
                    .focused($isTextFieldFocused)
                    .onAppear {
                        isTextFieldFocused = true
                    }
                    .onChange(of: isTextFieldFocused) { _, isFocused in
                        if !isFocused {
                            onFinishEditing()
                        }
                    }
                    .onSubmit(onFinishEditing)
            } else {
                Text(player.name)
            }

            Spacer()

            Text("\(player.point) pt")
                .foregroundStyle(.secondary)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if canEdit && !isEditing {
                onStartEditing()
            }
        }
    }
}

struct SetupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SetupView(viewModel: SetupViewModel(), onStart: {})
        }
    }
}
