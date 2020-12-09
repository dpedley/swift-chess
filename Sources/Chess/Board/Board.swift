//
//  Board.swift
//
//  Created by Douglas Pedley on 1/5/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

extension Chess {
    struct Board {
        let populateExpensiveVisuals: Bool
        var squares: [Square] = []
        var turns: [Turn] = []
        var isInCheck: Bool?
        var playingSide: Side = .white {
            didSet {
                // Only do this for an active visual board, it's expensive for a NilVisualizer
                if self.populateExpensiveVisuals {
                    isInCheck = square(squareForActiveKing.position, canBeAttackedBy: playingSide)
                } else {
                    isInCheck = nil
                }
            }
        }
        var lastMove: Move? {
            guard let lastTurn = turns.last else { return nil }
            if let move = lastTurn.black {
                return move
            }
            return lastTurn.white
        }
        var fullMoves = 1 // This is intentionally 1 even at the games start.
        var enPassantPosition: Position? { return lastEnPassantPosition() }
        var squareForActiveKing: Chess.Square { return findKing(playingSide) }
        init(populateExpensiveVisuals: Bool = false) {
            self.populateExpensiveVisuals = populateExpensiveVisuals
            for index in 0...63 {
                let newSquare = Square(position: Position(index))
                squares.append(newSquare)
            }
        }
        init(FEN: String, populateExpensiveVisuals: Bool = false) {
            self.init(populateExpensiveVisuals: populateExpensiveVisuals)
            self.resetBoard(FEN: FEN)
        }
    }
}
