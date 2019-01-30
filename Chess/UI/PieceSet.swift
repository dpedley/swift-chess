//
//  PieceSet.swift
//  phasestar
//
//  Created by Douglas Pedley on 1/12/19.
//  Copyright © 2019 d0. All rights reserved.
//

import UIKit

extension Chess.UI {
    
    typealias PieceSet = [Chess.UI.Piece : UIImage]
    
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
    
    static func loadPieces(themeName: String) -> [Chess.UI.Piece : UIImage] {
        guard let blackPawn = UIImage(named: "bP"),
            let blackKnight = UIImage(named: "bN"),
            let blackBishop = UIImage(named: "bB"),
            let blackRook = UIImage(named: "bR"),
            let blackQueen = UIImage(named: "bQ"),
            let blackKing = UIImage(named: "bK"),
            let whitePawn = UIImage(named: "wP"),
            let whiteKnight = UIImage(named: "wN"),
            let whiteBishop = UIImage(named: "wB"),
            let whiteRook = UIImage(named: "wR"),
            let whiteQueen = UIImage(named: "wQ"),
            let whiteKing = UIImage(named: "wK") else {
                fatalError("Theme not found: \(themeName)")
        }
        return [
            Chess.UI.Piece.blackPawn : blackPawn,
            Chess.UI.Piece.blackKnight : blackKnight,
            Chess.UI.Piece.blackBishop : blackBishop,
            Chess.UI.Piece.blackRook : blackRook,
            Chess.UI.Piece.blackQueen : blackQueen,
            Chess.UI.Piece.blackKing : blackKing,
            Chess.UI.Piece.whitePawn : whitePawn,
            Chess.UI.Piece.whiteKnight : whiteKnight,
            Chess.UI.Piece.whiteBishop : whiteBishop,
            Chess.UI.Piece.whiteRook : whiteRook,
            Chess.UI.Piece.whiteQueen : whiteQueen,
            Chess.UI.Piece.whiteKing : whiteKing ]
    }
}

