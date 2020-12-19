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

extension Chess.Board {
    func validVariantExists(for side: Chess.Side) -> Bool {
        for square in squares {
            if let piece = square.piece, piece.side == side,
               let toSquares = square.buildMoveDestinations(board: self) {
                // Try to create a tmp board from every square this piece thinks it can attack.
                for toSquare in toSquares {
                    let moveAttempt = Chess.Move(side: side, start: square.position, end: toSquare)
                    let boardChange = Chess.BoardChange.moveMade(move: moveAttempt)
                    let variant = Chess.SingleMoveVariant(originalFEN: self.FEN,
                                                          changesToAttempt: [boardChange],
                                                          deepVariant: true)
                    if variant.move != nil {
                        return true
                    }
                }
            }
        }
        return false
    }
    func createValidVariants(for side: Chess.Side, deepVariants: Bool = false) -> [Chess.SingleMoveVariant]? {
        // TODO: why doesn't this build attack variants.
        var boards: [Chess.SingleMoveVariant] = []
        let currentFEN = self.FEN
        for square in squares {
            if let piece = square.piece, piece.side == side,
               let toSquares = square.buildMoveDestinations(board: self) {
                    // Try to create a tmp board from every square this piece thinks it can attack.
                for toSquare in toSquares {
                    var moveAttempt = Chess.Move(side: side, start: square.position, end: toSquare)
                    var tmpBoard = Chess.Board(FEN: currentFEN)
                    let attempt = tmpBoard.attemptMove(&moveAttempt)
                    switch attempt {
                    case .success:
                        let change = Chess.BoardChange.moveMade(move: moveAttempt.clone())
                        let variant = Chess.SingleMoveVariant(originalFEN: self.FEN,
                                                              changesToAttempt: [change],
                                                              deepVariant: deepVariants)
                        if variant.move != nil {
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
    func square(_ position: Chess.Position, canBeAttackedBy side: Chess.Side) -> Bool {
        let attackers = allSquaresAttacking(squares[position], side: side, applyVariants: true)
        return attackers.count > 0
    }
    func square(_ position: Chess.Position, isDefendedBy side: Chess.Side) -> Bool {
        var shallowCopy = Chess.Board(FEN: FEN)
        // Make sure the spot can be attacked in our test by placing an opposing pawn there.
        shallowCopy.squares[position].piece = Chess.Piece(side: side.opposingSide, pieceType: .pawn(hasMoved: true))
        let attackers = shallowCopy.allSquaresAttacking(squares[position], side: side, applyVariants: true)
        return attackers.count > 0
    }
    func areThereAnyValidMoves() -> Bool {
        let currentFEN = self.FEN
        for square in squares {
            guard let piece = square.piece, piece.side == playingSide,
                  let toSquares = square.buildMoveDestinations(board: self) else {
                    continue
            }
            for toSquare in toSquares {
                var tmpBoard = Chess.Board(FEN: currentFEN)
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
            if !square.isEmpty {
                indices.append(square.position)
            }
        })
        return indices
    }
    func pieceWeights() -> GameAnalysis {
        var pieceWeights: GameAnalysis = [.black: 0, .white: 0]
        for square in squares {
            guard let piece = square.piece else { continue }
            pieceWeights[piece.side] = pieceWeights.value(for: piece.side) + piece.weight
        }
        return pieceWeights
    }
}
