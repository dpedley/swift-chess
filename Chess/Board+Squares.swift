//
//  Board+Squares.swift
//  phasestar
//
//  Created by Douglas Pedley on 1/9/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

protocol Chess_Index {
    static var index: Int { get }
}

extension Chess_Index {
    static func square(on board: Chess.Board) -> Chess.Square {
            return board.squares[index]
    }
    static func hasMoved(on board: Chess.Board) -> Bool {
        return (board.squares[index].piece?.hasMoved) ?? true
    }
}

extension Chess.Board {
    enum Black {
        enum King:       Chess_Index { static let index: Int = 4 }
        enum Queen:      Chess_Index { static let index: Int = 3 }
        enum KingsSide {
            enum Rook:   Chess_Index { static let index: Int = 7 }
            enum Knight: Chess_Index { static let index: Int = 6 }
            enum Bishop: Chess_Index { static let index: Int = 5 }
        }
        enum QueensSide {
            enum Rook:   Chess_Index { static let index: Int = 0 }
            enum Knight: Chess_Index { static let index: Int = 1 }
            enum Bishop: Chess_Index { static let index: Int = 2 }
        }
    }
    enum White {
        enum King:       Chess_Index { static let index: Int = 60 }
        enum Queen:      Chess_Index { static let index: Int = 59 }
        enum KingsSide {
            enum Rook:   Chess_Index { static let index: Int = 63 }
            enum Knight: Chess_Index { static let index: Int = 62 }
            enum Bishop: Chess_Index { static let index: Int = 61 }
        }
        enum QueensSide {
            enum Rook:   Chess_Index { static let index: Int = 56 }
            enum Knight: Chess_Index { static let index: Int = 57 }
            enum Bishop: Chess_Index { static let index: Int = 58 }
        }
    }
    
    func startingSquare(for side: Chess.Side, pieceType: Chess.PieceType, kingSide: Bool = true) -> Chess.Square {
        switch pieceType {
        case .pawn:
            fatalError("Pawns don't have unique squares.")
        case .knight:
            if side == .black {
                if kingSide {
                    return Chess.Board.Black.KingsSide.Knight.square(on: self)
                }
                return Chess.Board.Black.QueensSide.Knight.square(on: self)
            }
            if kingSide {
                return Chess.Board.White.KingsSide.Knight.square(on: self)
            }
            return Chess.Board.White.QueensSide.Knight.square(on: self)
        case .bishop:
            if side == .black {
                if kingSide {
                    return Chess.Board.Black.KingsSide.Bishop.square(on: self)
                }
                return Chess.Board.Black.QueensSide.Bishop.square(on: self)
            }
            if kingSide {
                return Chess.Board.White.KingsSide.Bishop.square(on: self)
            }
            return Chess.Board.White.QueensSide.Bishop.square(on: self)
        case .rook:
            if side == .black {
                if kingSide {
                    return Chess.Board.Black.KingsSide.Rook.square(on: self)
                }
                return Chess.Board.Black.QueensSide.Rook.square(on: self)
            }
            if kingSide {
                return Chess.Board.White.KingsSide.Rook.square(on: self)
            }
            return Chess.Board.White.QueensSide.Rook.square(on: self)
        case .queen:
            if side == .black {
                return Chess.Board.Black.Queen.square(on: self)
            }
            return Chess.Board.White.Queen.square(on: self)
        case .king:
            if side == .black {
                return Chess.Board.Black.King.square(on: self)
            }
            return Chess.Board.White.King.square(on: self)
        }
    }
    
    func isValid(startingSquare square: Chess.Square, for piece: Chess.Piece) -> Bool {
        switch piece.pieceType {
        case .pawn:
            if square.position.rank==7 && piece.side == .black {
                return true
            }
            if square.position.rank==2 && piece.side == .white {
                return true
            }
            return false;
        case .knight:
            if piece.side == .black {
                return (square.position == Chess.Board.Black.QueensSide.Knight.index) ||
                    (square.position == Chess.Board.Black.KingsSide.Knight.index)
            }
            return (square.position == Chess.Board.White.QueensSide.Knight.index) ||
                (square.position == Chess.Board.White.KingsSide.Knight.index)
        case .bishop:
            if piece.side == .black {
                return (square.position == Chess.Board.Black.QueensSide.Bishop.index) ||
                    (square.position == Chess.Board.Black.KingsSide.Bishop.index)
            }
            return (square.position == Chess.Board.White.QueensSide.Bishop.index) ||
                (square.position == Chess.Board.White.KingsSide.Bishop.index)
        case .rook:
            if piece.side == .black {
                return (square.position == Chess.Board.Black.QueensSide.Rook.index) ||
                    (square.position == Chess.Board.Black.KingsSide.Rook.index)
            }
            return (square.position == Chess.Board.White.QueensSide.Rook.index) ||
                (square.position == Chess.Board.White.KingsSide.Rook.index)
        case .queen:
            if piece.side == .black {
                return square.position == Chess.Board.Black.Queen.index
            }
            return square.position == Chess.Board.White.Queen.index
        case .king:
            if piece.side == .black {
                return square.position == Chess.Board.Black.King.index
            }
            return square.position == Chess.Board.White.King.index
        }
    }
    
}
