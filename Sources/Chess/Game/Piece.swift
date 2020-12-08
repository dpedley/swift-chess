//
//  Piece.swift
//
//  Created by Douglas Pedley on 1/5/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

extension Chess {
    
    struct Piece {
        enum DefaultType {
            static let Pawn = PieceType.pawn(hasMoved: false)
            static let Knight = PieceType.knight
            static let Bishop = PieceType.bishop
            static let Rook = PieceType.rook(hasMoved: false, isKingSide: false)
            static let Queen = PieceType.queen
            static let King = PieceType.king(hasMoved: false)
        }
        
        let side: Side
        let pieceType: PieceType
        let UI: UI.Piece
        var FEN: String {
            switch side {
            case .black:
                return pieceType.fen(.black)
            case .white:
                return pieceType.fen(.white)
            }
        }
        var hasMoved: Bool { return pieceType.hasMoved }

        init(side: Side, pieceType: PieceType) {
            self.side = side
            self.pieceType = pieceType
            self.UI = Chess.UI.Piece(side: side, pieceType: pieceType)
        }
        
        static func from(fen: String) -> Piece? {
            guard fen.count == 1 else {
                fatalError("Couldn't create a piece from [\(fen)]")
            }
            let lower = fen.lowercased()
            let side: Side = (lower == fen) ? .black : .white
            var foundType: PieceType?
            if lower == "p" {
                foundType = .pawn(hasMoved: false)
            } else if lower == "n" {
                foundType = .knight(hasMoved: false)
            } else if lower == "b" {
                foundType = .bishop(hasMoved: false)
            } else if lower == "r" {
                foundType = .rook(hasMoved: false, isKingSide: true)
            } else if lower == "q" {
                foundType = .queen(hasMoved: false)
            } else if lower == "k" {
                foundType = .king(hasMoved: false)
            }
            
            guard let pieceType = foundType else {
                return nil
            }
            return Piece(side: side, pieceType: pieceType)
        }
        
        var unicode: String {
            switch self.pieceType {
            case .pawn(_):
                return side == .black ? "\u{265F}" : "\u{2659}"
            case .knight(_):
                return side == .black ? "\u{265E}" : "\u{2658}"
            case .bishop(_):
                return side == .black ? "\u{265D}" : "\u{2657}"
            case .rook(_, _):
                return side == .black ? "\u{265C}" : "\u{2656}"
            case .queen(_):
                return side == .black ? "\u{265B}" : "\u{2655}"
            case .king(_):
                return side == .black ? "\u{265A}" : "\u{2654}"
            }
        }
        
        /// Sourced here:https://en.wikipedia.org/wiki/Chess_piece_relative_value
        /// Went with AlphaZero - 1.0 3.05    3.33    5.63    9.5
        var weight: Double {
            switch self.pieceType {
            case .pawn(_):
                return 1.0
            case .knight(_):
                return 3.05
            case .bishop(_):
                return 3.33
            case .rook(_, _):
                return 5.63
            case .queen(_):
                return 9.5
            case .king(_):
                return 0.0
            }
        }
    }
}


