//
//  Piece+Game.swift
//
//  Created by Douglas Pedley on 1/11/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

extension Chess.Piece {
    func isAttackValid(_ move: inout Chess.Move) -> Bool {
        // Attacks are moves, except when they aren't
        switch pieceType {
        case .pawn:
            if move.rankDirection == side.rankDirection,
                move.rankDistance == 1, move.fileDistance == 1 {
                return true
            }
            return false
        default:
            return isMoveValid(&move)
        }
    }
    func isMoveValid(_ move: inout Chess.Move) -> Bool {
        switch pieceType {
        case .knight:
            return Chess.Rules.isValidKnightMove(move)
        case .bishop:
            return Chess.Rules.isValidBishopMove(move)
        case .rook:
            return Chess.Rules.isValidRookMove(move)
        case .queen:
            return Chess.Rules.isValidQueenMove(move)
        case .pawn(let hasMoved):
            do {
                return try Chess.Rules.isValidPawnMove(move, hasMoved: hasMoved)
            } catch let error {
                guard let sideEffect = error as? Chess.Move.SideEffect else {
                    fatalError("Unknown error - \(error)")
                }
                move.sideEffect = sideEffect
                return true
            }
        case .king(let hasMoved):
            do {
                return try Chess.Rules.isValidKingMove(move, hasMoved: hasMoved)
            } catch let error {
                guard let sideEffect = error as? Chess.Move.SideEffect else {
                    Chess.log.critical("Unknown king error: \(error)")
                    fatalError("Unknown king error - \(error)")
                }
                move.sideEffect = sideEffect
                return true
            }
        }
    }
    func isLastRank(_ position: Chess.Position) -> Bool {
        // Attacks are moves, except when they aren't
        switch pieceType {
        case .pawn:
            // It's a pawn, based on the side return whether we're at the final step.
            return side == .black ? (position.rank==1) : (position.rank==8)
        default:
            // All other pieces can move endlessly
            return false
        }
    }
    // The FEN Indices for the sqaures this piece will pass through when making this move.
    func steps(for move: Chess.Move) -> [Chess.Position]? {
        switch self.pieceType {
        case .knight:
            // Jumps have no steps
            return nil
        default:
            var squaresInBetween: [Chess.Position] = []
            var nextPosition: Chess.Position = move.start.adjacentPosition(rankOffset: move.rankDirection,
                                                                           fileOffset: move.fileDirection)
            while nextPosition != move.end {
                squaresInBetween.append(nextPosition)
                nextPosition = nextPosition.adjacentPosition(rankOffset: move.rankDirection,
                                                             fileOffset: move.fileDirection)
            }
            guard squaresInBetween.count > 0 else { return nil }
            return squaresInBetween
        }
    }
}
