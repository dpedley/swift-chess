//
//  Board+Analysis.swift
//
//  Created by Douglas Pedley on 1/6/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

typealias GameAnalysis = [Chess.Side: Double]
extension GameAnalysis {
    func value(for side: Chess.Side) -> Double {
        return self[side] ?? 0
    }
}

extension Chess.Board  {
    func validVariantExists(for side: Chess.Side) -> Bool {
        for square in squares {
            if let piece = square.piece, piece.side == side,
               let toSquares = square.buildMoveDestinations(board: self) {
                // Try to create a tmp board from every square this piece thinks it can attack.
                for toSquare in toSquares {
                    let moveAttempt = Chess.Move(side: side, start: square.position, end: toSquare)
                    let variant: Chess.SingleMoveVariant = self.variant(with: moveAttempt)
                    if let _ = variant.move {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func createValidVariants(for side: Chess.Side) -> [Chess.SingleMoveVariant]? {
        var boards: [Chess.SingleMoveVariant] = []
        let currentFEN = self.FEN

        for square in squares {
            if let piece = square.piece, piece.side == side,
               let toSquares = square.buildMoveDestinations(board: self) {
                    // Try to create a tmp board from every square this piece thinks it can attack.
                for toSquare in toSquares {
                    var moveAttempt = Chess.Move(side: side, start: square.position, end: toSquare)
                    let tmpBoard = Chess.Board(FEN: currentFEN)
                    let attempt = tmpBoard.attemptMove(&moveAttempt)
                    switch attempt {
                    case .success:
                        let variant: Chess.SingleMoveVariant = self.variant(with: moveAttempt)
                        if let _ = variant.move {
                            boards.append(variant)
                        }
                    default:
                        break
                    }
                }
            }
        }
        if boards.count == 0 {
            return nil
        }
        return boards
    }
    
    // This doesn't check deep lines, just basic chess mechanics. (no pins, side effects etc.)
    func shallowAttemptMove(_ move: Chess.Move) -> Chess.Move.Result {
        // Make a mutable copy for any side effects, these will not propogate to the caller.
        var shallowMove = move
        if let failedResult = prepareMove(&shallowMove) { return failedResult }

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
                  let toSquares = square.buildMoveDestinations(board: self) else {
                    continue
            }
            
            for toSquare in toSquares {
                let tmpBoard = Chess.Board(FEN: currentFEN)
                var moveAttempt = Chess.Move(side: self.playingSide, start: square.position, end: toSquare)
                let attempt = tmpBoard.attemptMove(&moveAttempt)
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
    
    var pieceWeights: GameAnalysis {
        var pieceWeights: GameAnalysis = [.black: 0, .white: 0]
        for square in squares {
            guard let piece = square.piece else { continue }
            pieceWeights[piece.side] = pieceWeights.value(for: piece.side) + piece.weight
        }
        return pieceWeights
    }
}
