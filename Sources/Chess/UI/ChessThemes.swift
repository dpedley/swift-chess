//
//  ChessThemes.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/25/20.
//
import SwiftUI

public extension Chess.UI {
    struct ChessTheme {
        @AppStorage("boardColor", store: ChessEnvironment.defaults)
            var color: BoardColor = .blue
    }
    enum BoardColor: String {
        case brown = "brown"
        case blue = "blue"
        case green = "green"
        case purple = "purple"
        public var dark: Color {
            switch self {
            case .brown:
                return .chessBoardBrown
            case .blue:
                return .chessBoardBlue
            case .green:
                return .chessBoardGreen
            case .purple:
                return .chessBoardPurple
            }
        }
        public var light: Color {
            switch self {
            case .brown:
                return .chessBoardBrownLight
            case .blue:
                return .chessBoardBlueLight
            case .green:
                return .chessBoardGreenLight
            case .purple:
                return .chessBoardPurpleLight
            }
        }
        public var name: LocalizedStringKey {
            switch self {
            case .brown:
                return "Brown"
            case .blue:
                return "Blue"
            case .green:
                return "Green"
            case .purple:
                return "Purple"
            }
        }
    }
}

private extension Color {
    static func hexColor(red: Int, green: Int, blue: Int) -> Color {
        return Color(red: Double(red)/256.0, green: Double(green)/256.0, blue: Double(blue)/256.0)
    }
    static let chessBoardBrown = hexColor(red: 0xae, green: 0x8a, blue: 0x68) // AE8A68
    static let chessBoardBrownLight = hexColor(red: 0xec, green: 0xda, blue: 0xb9) // ECDAB9
    static let chessBoardGreen = hexColor(red: 0x8c, green: 0xa5, blue: 0x6d) // 8CA56D
    static let chessBoardGreenLight = hexColor(red: 0xff, green: 0xff, blue: 0xe0) // FFFFE0
    static let chessBoardBlue = hexColor(red: 0x90, green: 0xa1, blue: 0xac) // 90A1AC
    static let chessBoardBlueLight = hexColor(red: 0xdf, green: 0xe3, blue: 0xe6) // DFE3E6
    static let chessBoardPurple = hexColor(red: 0x76, green: 0x4c, blue: 0x89) // 764C89
    static let chessBoardPurpleLight = hexColor(red: 0x9c, green: 0x91, blue: 0xae) // 9C91AE
}

struct ChessBoardColorsPreview: PreviewProvider {
    static var brown: ChessStore = {
        var store = ChessStore()
        store.environment.theme.color = .brown
        return store
    }()
    static var blue: ChessStore = {
        var store = ChessStore()
        store.environment.theme.color = .blue
        return store
    }()
    static var green: ChessStore = {
        var store = ChessStore()
        store.environment.theme.color = .green
        return store
    }()
    static var purple: ChessStore = {
        var store = ChessStore()
        store.environment.theme.color = .purple
        return store
    }()
    static var previews: some View {
        VStack {
            HStack {
                BoardView()
                    .environmentObject(brown)
                BoardView()
                    .environmentObject(blue)
            }
            HStack {
                BoardView()
                    .environmentObject(green)
                BoardView()
                    .environmentObject(purple)
            }
        }
    }
}
