//
//  Board+Squares.swift
//  phasestar
//
//  Created by Douglas Pedley on 1/9/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

public protocol Chess_Index {
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
    func isValid(startingSquare square: Chess.Square, for piece: Chess.Piece) -> Bool {
        switch piece.pieceType {
        case .pawn:
            return piece.side == .black ? square.position.rank==7 : square.position.rank==2
        case .knight:
            return piece.side == .black ?
                Chess.Rules.startingPositionsForBlackKnights.contains(square.position) :
                Chess.Rules.startingPositionsForWhiteKnights.contains(square.position)
        case .bishop:
            return piece.side == .black ?
                Chess.Rules.startingPositionsForBlackBishops.contains(square.position) :
                Chess.Rules.startingPositionsForWhiteBishops.contains(square.position)
        case .rook:
            return piece.side == .black ?
                Chess.Rules.startingPositionsForBlackRooks.contains(square.position) :
                Chess.Rules.startingPositionsForWhiteRooks.contains(square.position)
        case .queen:
            return piece.side == .black ? square.position == .d8 : square.position == .d1
        case .king:
            return piece.side == .black ? square.position == .e8 : square.position == .e1
        }
    }
}
