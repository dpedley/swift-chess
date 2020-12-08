//
//  Board.swift
//
//  Created by Douglas Pedley on 1/5/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

public protocol Chess_GameVisualizing: class {
    func apply(board: Chess_PieceCoordinating, status: Chess.UI.Status)
    func apply(board: Chess_PieceCoordinating, updates: [Chess.UI.Update])
    var humanInteracting: Bool { get }
}

extension Chess_GameVisualizing {
    var humanInteracting: Bool {
        return false
    }
}
public protocol Chess_PieceCoordinating: class {
    var squareForActiveKing: Chess.Square { get }
    var squares: [Chess.Square] { get }
    var positionsForOccupiedSquares: [Chess.Position] { get }
    var playingSide: Chess.Side { get }
    var lastMove: Chess.Move? { get }
    var ui: Chess_GameVisualizing { get }
}

extension Chess {
    struct Board: Identifiable {
        let id = UUID()
        let populateExpensiveVisuals: Bool
        var squares: [Square] = []
        var turns: [Turn] = []
        var isInCheck: Bool? = nil
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
        var FEN: String { return createCurrentFENString() }
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
