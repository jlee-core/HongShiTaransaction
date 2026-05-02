import SwiftUI

struct GameStartOptionView: View {
    let onNormalGame: () -> Void
    let onSurrender: () -> Void
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Button("チームを決める", action: onNormalGame)
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)

            Button("降参", action: onSurrender)
                .buttonStyle(.bordered)
                .frame(maxWidth: .infinity)

            Spacer()
        }
        .padding()
        .navigationTitle("ゲーム開始")
        .toolbar {
            ToolbarItem {
                Button("設定", action: onBack)
            }
        }
    }
}

struct GameStartOptionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GameStartOptionView(
                onNormalGame: {},
                onSurrender: {},
                onBack: {}
            )
        }
    }
}
