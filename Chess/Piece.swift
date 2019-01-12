//
//  Piece.swift
//  LeelaChessZero
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
        var FEN: String {
            switch side {
            case .black:
                return pieceType.fen(.black)
            case .white:
                return pieceType.fen(.white)
            }
        }
        var hasMoved: Bool { return pieceType.hasMoved }

        static func from(fen: String) -> Piece? {
            guard fen.count == 1 else {
                fatalError("Couldn't create a piece from [\(fen)]")
            }
            let lower = fen.lowercased()
            let side: Side = (lower == fen) ? .black : .white
            var foundType: PieceType? = nil
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
    }
}


