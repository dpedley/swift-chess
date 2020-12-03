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
        
        // Make sure it's a move
        if (move.rankDistance==0) && (move.fileDistance==0) {
            return false
        }
        
        switch pieceType {
        case .pawn(let hasMoved):
            // Only forward
            if move.rankDirection == side.rankDirection {
                if move.rankDistance == 1, move.fileDistance == 0 { // Plain vanilla pawn move
                    return true
                }
                if move.rankDistance == 2, move.fileDistance == 0 {
                    // Two step is only allow as the first move
                    if hasMoved {
                        return false
                    }
                    // The move is valid. Before we return, make sure to attach the enPassantPosition
                    let jumpPosition = (move.start + move.end) / 2
                    move.sideEffect = Chess.Move.SideEffect.enPassantInvade(territory: jumpPosition, invader: move.end)
                    return true
                }
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
            if !hasMoved, move.rankDistance == 0, move.fileDistance == 2 {
                let rookDistance = move.fileDirection < 0 ? 2 : 1
                let rook = move.end + (move.fileDirection * rookDistance)
                move.sideEffect = Chess.Move.SideEffect.castling(rook: rook, destination: move.end - move.fileDirection) // Note "move.end - move.fileDirection" is always the square the king passes over when castling.
                return true
            }
            return false
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
