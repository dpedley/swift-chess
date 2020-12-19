//
//  Board.swift
//
//  Created by Douglas Pedley on 1/5/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

public extension Chess {
    struct Board {
        let populateExpensiveVisuals: Bool
        public var squares: [Square] = []
        public var turns: [Turn] = []
        public var isInCheck: Bool?
        public var playingSide: Side = .white {
            didSet {
                // Only do this for an active visual board, it's expensive for a NilVisualizer
                if self.populateExpensiveVisuals {
                    isInCheck = square(squareForActiveKing.position, canBeAttackedBy: playingSide)
                } else {
                    isInCheck = nil
                }
            }
        }
        public var lastMove: Move? {
            guard let lastTurn = turns.last else { return nil }
            if let move = lastTurn.black {
                return move
            }
            return lastTurn.white
        }
        public var fullMoves = 1 // This is intentionally 1 even at the games start.
        var enPassantPosition: Position? { return lastEnPassantPosition() }
        public var squareForActiveKing: Chess.Square { return findKing(playingSide) }
        public init(populateExpensiveVisuals: Bool = false) {
            self.populateExpensiveVisuals = populateExpensiveVisuals
            for index in 0...63 {
                let newSquare = Square(position: Position(index))
                squares.append(newSquare)
            }
        }
        public init(FEN: String, populateExpensiveVisuals: Bool = false) {
            self.init(populateExpensiveVisuals: populateExpensiveVisuals)
            self.resetBoard(FEN: FEN)
        }
    }
}
