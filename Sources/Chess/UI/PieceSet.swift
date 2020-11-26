//
//  PieceSet.swift
//  phasestar
//
//  Created by Douglas Pedley on 1/12/19.
//  Copyright © 2019 d0. All rights reserved.
//

import SwiftUI

extension Chess.UI {
    
    typealias PieceSet = [Chess.UI.Piece : PieceView]
    
    public enum Selection {
        case none
        case premove
        case highlight
        case target
        case attention
    }
    
    public enum Piece: String {
        case blackKing   = "\u{265A}"
        case blackQueen  = "\u{265B}"
        case blackRook   = "\u{265C}"
        case blackBishop = "\u{265D}"
        case blackKnight = "\u{265E}"
        case blackPawn   = "\u{265F}"
        case whiteKing   = "\u{2654}"
        case whiteQueen  = "\u{2655}"
        case whiteRook   = "\u{2656}"
        case whiteBishop = "\u{2657}"
        case whiteKnight = "\u{2658}"
        case whitePawn   = "\u{2659}"
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
        func asView() -> PieceView? {
            return PieceView(self)

        }
        init() { self = .none }
        init(side: Chess.Side, pieceType: Chess.PieceType) {
            switch pieceType {
            case .pawn(_):
                self = (side == .black) ? .blackPawn : .whitePawn
            case .knight(_):
                self = (side == .black) ? .blackKnight : .whiteKnight
            case .bishop(_):
                self = (side == .black) ? .blackBishop : .whiteBishop
            case .rook(_, _):
                self = (side == .black) ? .blackRook : .whiteRook
            case .queen(_):
                self = (side == .black) ? .blackQueen : .whiteQueen
            case .king(_):
                self = (side == .black) ? .blackKing : .whiteKing
            }
        }

    }
    
    static func loadPieceSet(themeName: String) -> PieceSet {
        // TODO support themes
        return [
            Chess.UI.Piece.blackPawn   : PieceView(.pawn, style: .black),
            Chess.UI.Piece.blackKnight : PieceView(.knight, style: .black),
            Chess.UI.Piece.blackBishop : PieceView(.bishop, style: .black),
            Chess.UI.Piece.blackRook   : PieceView(.rook, style: .black),
            Chess.UI.Piece.blackQueen  : PieceView(.queen, style: .black),
            Chess.UI.Piece.blackKing   : PieceView(.king, style: .black),
            Chess.UI.Piece.whitePawn   : PieceView(.pawn, style: .white),
            Chess.UI.Piece.whiteKnight : PieceView(.knight, style: .white),
            Chess.UI.Piece.whiteBishop : PieceView(.bishop, style: .white),
            Chess.UI.Piece.whiteRook   : PieceView(.rook, style: .white),
            Chess.UI.Piece.whiteQueen  : PieceView(.queen, style: .white),
            Chess.UI.Piece.whiteKing   : PieceView(.king, style: .white) ]
    }
}

