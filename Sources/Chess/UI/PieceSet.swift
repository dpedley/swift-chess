//
//  PieceSet.swift
//
//  Created by Douglas Pedley on 1/12/19.
//  Copyright © 2019 d0. All rights reserved.
//

import SwiftUI

extension Chess.UI {
    public enum Selection {
        case none
        case premove
        case highlight
        case target
        case attention
    }
    public enum Piece: String, Equatable {
        case blackKing = "\u{265A}"
        case blackQueen = "\u{265B}"
        case blackRook = "\u{265C}"
        case blackBishop = "\u{265D}"
        case blackKnight = "\u{265E}"
        case blackPawn = "\u{265F}"
        case whiteKing = "\u{2654}"
        case whiteQueen = "\u{2655}"
        case whiteRook = "\u{2656}"
        case whiteBishop = "\u{2657}"
        case whiteKnight = "\u{2658}"
        case whitePawn = "\u{2659}"
        case none = " "
        var FEN: String {
            switch self {
            case .blackKing:
                return "k"
            case .blackQueen:
                return "q"
            case .blackRook:
                return "r"
            case .blackBishop:
                return "b"
            case .blackKnight:
                return "n"
            case .blackPawn:
                return "p"
            case .whiteKing:
                return "K"
            case .whiteQueen:
                return "Q"
            case .whiteRook:
                return "R"
            case .whiteBishop:
                return "B"
            case .whiteKnight:
                return "N"
            case .whitePawn:
                return "P"
            case .none:
                return " "
            }
        }
        init() { self = .none }
        init(side: Chess.Side, pieceType: Chess.PieceType) {
            switch pieceType {
            case .pawn:
                self = (side == .black) ? .blackPawn : .whitePawn
            case .knight:
                self = (side == .black) ? .blackKnight : .whiteKnight
            case .bishop:
                self = (side == .black) ? .blackBishop : .whiteBishop
            case .rook:
                self = (side == .black) ? .blackRook : .whiteRook
            case .queen:
                self = (side == .black) ? .blackQueen : .whiteQueen
            case .king:
                self = (side == .black) ? .blackKing : .whiteKing
            }
        }
    }
}
