//
//  ChessThemes.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/25/20.
//
import SwiftUI

public extension Chess.UI {
    struct ChessTheme {
        var color: BoardColor = .blue
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
    static func hexColor(red: Int, green: Int, blue: Int) -> Color {
        return Color(red: Double(red)/256.0, green: Double(blue)/256.0, blue: Double(blue)/256.0)
    }
    static let chessBoardBrown = hexColor(red: 0xb5, green: 0x88, blue: 0x63) // b58863
    static let chessBoardBrownLight = hexColor(red: 0xf0, green: 0xd9, blue: 0xb5) // f0d9b5
    static let chessBoardGreen = hexColor(red: 0x86, green: 0xa6, blue: 0x66) // 86a666
    static let chessBoardGreenLight = hexColor(red: 0xff, green: 0xff, blue: 0xdd) // ffffdd
    static let chessBoardBlue = hexColor(red: 0x8c, green: 0xa2, blue: 0xad) // 8ca2ad
    static let chessBoardBlueLight = hexColor(red: 0xde, green: 0xe3, blue: 0xe6) // dee3e6
    static let chessBoardPurple = hexColor(red: 0x7d, green: 0x4a, blue: 0x8d) // 7d4a8d
    static let chessBoardPurpleLight = hexColor(red: 0x9f, green: 0x90, blue: 0xb0) // 9f90b0
}
