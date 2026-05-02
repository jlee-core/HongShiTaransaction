import SwiftUI

enum TeamColor: String, CaseIterable, Identifiable {
    case none
    case red
    case black

    var id: String { rawValue }

    var title: String {
        switch self {
        case .none:
            return "未選択"
        case .red:
            return "赤"
        case .black:
            return "黒"
        }
    }

    var displayColor: Color {
        switch self {
        case .none:
            return .secondary
        case .red:
            return .red
        case .black:
            return .primary
        }
    }

    var borderColor: Color {
        switch self {
        case .none:
            return .gray.opacity(0.35)
        case .red:
            return .red
        case .black:
            return .primary
        }
    }

    var nextSelection: TeamColor {
        switch self {
        case .none:
            return .red
        case .red:
            return .black
        case .black:
            return .red
        }
    }
}
