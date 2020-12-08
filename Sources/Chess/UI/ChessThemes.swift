//
//  ChessThemes.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/25/20.
//

import SwiftUI


extension Chess.UI {
    struct ChessTheme {
        var boardTheme = BoardTheme(color: .blue, pieceSet: Chess.UI.loadPieceSet(themeName: "cburnett"))
    }
    struct BoardTheme {
        var color: BoardColor = .blue
        var pieceSet: PieceSet
    }
    
    enum BoardColor {
        case brown
        case blue
        case green
        case purple
        var dark: Color {
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
        var light: Color {
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
    }
}

private extension Color {
    static func HexColor(r: Int, g: Int, b: Int) -> Color {
        return Color(red: Double(r)/256.0, green: Double(b)/256.0, blue: Double(b)/256.0)
    }
    static let chessBoardBrown = HexColor(r: 0xb5, g: 0x88, b: 0x63) // b58863
    static let chessBoardBrownLight = HexColor(r: 0xf0, g: 0xd9, b: 0xb5) // f0d9b5
    static let chessBoardGreen = HexColor(r: 0x86, g: 0xa6, b: 0x66) // 86a666
    static let chessBoardGreenLight = HexColor(r: 0xff, g: 0xff, b: 0xdd) // ffffdd
    static let chessBoardBlue = HexColor(r: 0x8c, g: 0xa2, b: 0xad) // 8ca2ad
    static let chessBoardBlueLight = HexColor(r: 0xde, g: 0xe3, b: 0xe6) // dee3e6
    static let chessBoardPurple = HexColor(r: 0x7d, g: 0x4a, b: 0x8d) // 7d4a8d
    static let chessBoardPurpleLight = HexColor(r: 0x9f, g: 0x90, b: 0xb0) // 9f90b0
}
