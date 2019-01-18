//
//  Board+Analysis.swift
//  LeelaChessZero
//
//  Created by Douglas Pedley on 1/6/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

extension Chess.Board  {
    func createVariantsForEveryValidMove() -> [Chess.SingleMoveVariant]? {
        var boards: [Chess.SingleMoveVariant] = []

        for square in squares {
            if let piece = square.piece, piece.side == playingSide,
                let toSquares = square.attackedSquares {
                // Try to create a tmp board from every square this piece thinks it can attack.
                for toSquare in toSquares {
                    let moveAttempt = Chess.Move(side: self.playingSide, start: square.position, end: toSquare.position)
                    let variant: Chess.SingleMoveVariant = self.variant(with: moveAttempt)
                    if let _ = variant.move {
                        boards.append(variant)
                    }
                }
            }
        }
        if boards.count == 0 {
            return nil
        }
        return boards
    }
    
    // This doesn't check deep lines, just basic chess mechanics. (no pins etc.)
    func shallowAttemptMove(_ move: Chess.Move) -> Chess.Move.Result {
        if let failedResult = prepareMove(move) { return failedResult }

        // Simulations aren't fully vetted, but still allowed to be commited
        move.setSimulated()
        
        // Before we `commit` the move grab the destination square's piece (if there is one) `commit` will over write it.
        let capturedPiece = squares[move.end].piece
        commit(move, capturedPiece: capturedPiece)
        return .success(capturedPiece: capturedPiece)
    }
    
    func variant(with move: Chess.Move) -> Chess.SingleMoveVariant {
        let change = Chess.BoardChange.moveMade(move: move.cloneForSimulation())
        return Chess.SingleMoveVariant(originalFEN: self.FEN, changesToAttempt: [change])
    }
    
    func areThereAnyValidMoves() -> Bool {
        let currentFEN = self.FEN
        for square in squares {
            guard let piece = square.piece, piece.side == playingSide,
                let toSquares = square.attackedSquares else {
                    continue
            }
            
            for toSquare in toSquares {
                let tmpBoard = Chess.Board(FEN: currentFEN)
                let moveAttempt = Chess.Move(side: self.playingSide, start: square.position, end: toSquare.position)
                let attempt = tmpBoard.attemptMove(moveAttempt)
                switch attempt {
                case .success:
                    return true
                default:
                    break
                }
            }
        }
        return false
    }

    var positionsForOccupiedSquares: [Chess.Position] {
        var indices: [Chess.Position] = []
        self.squares.forEach({square in
            if let _ = square.piece {
                indices.append(square.position)
            }
        })
        return indices
    }
}
