//
//  Board.swift
//  LeelaChessZero
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
    class Board: Chess_PieceCoordinating {        
        static let startingFEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
        let ui: Chess_GameVisualizing
        var squares: [Square] = []
        var turns: [Turn] = []
        var playingSide: Side = .white {
            didSet {
                let isInCheck: Bool
                // Only do this for an active visual board, it's expensive for a NilVisualizer
                if self.ui.humanInteracting {
                    isInCheck = squareForActiveKing.isUnderAttack
                } else {
                    isInCheck = false
                }
                self.ui.apply(board: self, status: Chess.UI.Status(nextToPlay: playingSide, isInCheck: isInCheck))
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

        init(ui: Chess_GameVisualizing = Chess.UI.Default.devNull) {
            self.ui = ui
            for index in 0...63 {
                let newSquare = Square(position: Position.from(FENIndex: index))
                newSquare.board = self
                squares.append(newSquare)
            }
        }
        
        convenience init(FEN: String) {
            self.init()
            self.resetBoard(FEN: FEN)
        }
    }
}
