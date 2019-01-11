//
//  Piece+Game.swift
//  phasestar
//
//  Created by Douglas Pedley on 1/11/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

extension Chess.Piece {
    func isMoveValid(_ move: Chess.Move, board: Chess.Board? = nil) -> Bool {
        
        // Make sure it's a move
        if (move.rankDistance==0) && (move.fileDistance==0) {
            return false
        }
        
        switch pieceType {
        case .pawn(let hasMoved):
            if move.rankDirection == side.rankDirection,
                move.rankDistance <= ((hasMoved) ? 1 : 2) {
                return true
            }
            return false
        case .knight:
            if (move.rankDistance==2 && move.fileDistance==1) ||
                (move.rankDistance==1 && move.fileDistance==2) {
                return true
            }
            return false
        case .bishop:
            if (move.rankDistance==move.fileDistance) {
                return true
            }
            return false
        case .rook:
            if (move.rankDistance==0) || (move.fileDistance==0) {
                return true
            }
            return false
        case .queen:
            // Like a bishop
            if (move.rankDistance==move.fileDistance) {
                return true
            }
            // Like a rook
            if (move.rankDistance==0) || (move.fileDistance==0) {
                return true
            }
            return false
        case .king(let hasMoved):
            if move.rankDistance<2, move.fileDistance<2 {
                return true
            }
            
            // Are we trying to castle?
            if !hasMoved, let board = board,
                move.fileDistance == 0, (move.rankDistance == -2 || move.rankDistance == 2) {
                switch move.sideEffect {
                case .notKnown:
                    print("Castling...")
                default:
                    break
                }
                let isKingSide: Bool = move.rankDirection > 0
                let square = board.startingSquare(for: side, pieceType: DefaultType.Rook, kingSide: isKingSide)
                if let rook = square.piece, case .rook(let hasMoved, _) = rook.pieceType, !hasMoved {
                    move.sideEffect = Chess.Move.SideEffect.castling(rook: square.position, destination: move.end - (move.fileDirection * -1))
                    return true
                }
            }
            return false
        }
    }
    
    func isAttackValid(_ move: Chess.Move) -> Bool {
        // Attacks are moves, except when they aren't
        switch pieceType {
        case .pawn:
            if move.rankDirection == side.rankDirection,
                move.rankDistance == 1, move.fileDistance == 1 {
                return true
            }
            return false
        default:
            return isMoveValid(move)
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
            var nextPosition: Chess.Position = move.start.adjacentPosition(rankOffset: move.rankDirection, fileOffset: move.fileDirection)
            while (nextPosition != move.end) {
                squaresInBetween.append(nextPosition)
                nextPosition = nextPosition.adjacentPosition(rankOffset: move.rankDirection, fileOffset: move.fileDirection)
            }
            guard squaresInBetween.count > 0 else { return nil }
            return squaresInBetween
        }
    }

}
