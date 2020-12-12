//
//  Piece+Game.swift
//  phasestar
//
//  Created by Douglas Pedley on 1/11/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

extension Chess.Piece {
    func isAttackValid(_ move: inout Chess.Move, board: Chess.Board? = nil) -> Bool {
        // Attacks are moves, except when they aren't
        switch pieceType {
        case .pawn:
            if move.rankDirection == side.rankDirection,
                move.rankDistance == 1, move.fileDistance == 1 {
                if let board = board {
                    // If we are passed a board, then it's only a valid attack if a piece is present.
                    guard let _ = board.squares[move.end].piece else {
                        return false
                    }
                }
                return true
            }
            return false
        default:
            return isMoveValid(&move, board: board)
        }
    }
    
    func isMoveValid(_ move: inout Chess.Move, board: Chess.Board? = nil) -> Bool {
        
        // Make sure it's a move
        if (move.rankDistance==0) && (move.fileDistance==0) {
            return false
        }
        
        switch pieceType {
        case .pawn(let hasMoved):
            // Only forward
            if move.rankDirection == side.rankDirection {
                if let _ = board?.squares[move.end].piece {
                    // There is a piece at the destination, pawns only move to empty squares (this is not an attack)
                    return false
                }
                if move.rankDistance == 1, move.fileDistance == 0 { // Plain vanilla pawn move
                    return true
                }
                if move.rankDistance == 2, move.fileDistance == 0 {
                    // Two step is only allow as the first move
                    if hasMoved {
                        return false
                    }
                    // Ensure the pawn isn't trying to jump a piece
                    let jumpPosition = (move.start + move.end) / 2
                    if let _ = board?.squares[jumpPosition].piece {
                        // There is a piece in the spot one space forward, we can't move 2 spaces.
                        return false
                    }
                    
                    // The move is valid. Before we return, make sure to attach the enPassantPosition
                    move.sideEffect = Chess.Move.SideEffect.enPassantInvade(territory: jumpPosition, invader: move.end)
                    return true
                }
                
                // Check the special case of EnPassant. The code would come through because the
                // destination square is empty. Which the system sees as a move, not an attack.
                if let enPassantPosition = board?.enPassantPosition, move.end == enPassantPosition, move.rankDistance == 1, move.fileDistance == 1 {
                    // We're capturing EnPassant, attach the SideEffect here.
                    move.sideEffect = Chess.Move.SideEffect.enPassantCapture(attack: move.end,
                                                                      trespasser: move.start.adjacentPosition(rankOffset: 0, fileOffset: move.fileDirection) )
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
                return isMovePathOpen(move, board: board)
            }
            return false
        case .rook:
            if (move.rankDistance==0) || (move.fileDistance==0) {
                return isMovePathOpen(move, board: board)
            }
            return false
        case .queen:
            // Like a bishop
            if (move.rankDistance==move.fileDistance) {
                return isMovePathOpen(move, board: board)
            }
            // Like a rook
            if (move.rankDistance==0) || (move.fileDistance==0) {
                return isMovePathOpen(move, board: board)
            }
            return false
        case .king(let hasMoved):
            if move.rankDistance<2, move.fileDistance<2 {
                return true
            }
            
            // Are we trying to castle?
            if !hasMoved, let board = board,
                move.rankDistance == 0, move.fileDistance == 2 {
                switch move.sideEffect {
                case .notKnown:
                    break
                    // TODO: revisit what this is for?
//                    print("Castling...")
                default:
                    break
                }
                let isKingSide: Bool = move.fileDirection > 0
                let square = board.startingSquare(for: side, pieceType: DefaultType.Rook, kingSide: isKingSide)
                if let rook = square.piece, case .rook(let hasMoved, _) = rook.pieceType, !hasMoved {
                    move.sideEffect = Chess.Move.SideEffect.castling(rook: square.position, destination: move.end - move.fileDirection) // Note "move.end - move.fileDirection" is always the square the king passes over when castling.
                    return true
                }
            }
            return false
        }
    }
    
    private func isMovePathOpen(_ move: Chess.Move, board: Chess.Board?) -> Bool {
        guard let board = board else {
            // there is no board so nothing left to confirm
            return true
        }
        
        let travel = move.rankDistance > move.fileDistance ? move.rankDistance : move.fileDistance
        guard travel>1 else {
            // We didn't travel far enough to be blocked
            return true
        }
        // Need to check steps between
        for tween in 1..<travel {
            let tweenPosition = Chess.Position.from(fileNumber: move.start.fileNumber + (tween * move.fileDirection),
                rank: move.start.rank + (tween * move.rankDirection))
            guard board.squares[tweenPosition].piece == nil else {
                return false
            }
        }
        return true

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
