//
//  Game+Status.swift
//  
//
//  Created by Douglas Pedley on 11/27/20.
//

import Foundation

extension Chess.Game {
    func buildCurrentStatus() -> Chess.GameStatus {
        guard let lastMove = board.lastMove else {
            if board.FEN == Chess.Board.startingFEN {
                return .notYetStarted
            }
            return .unknown
        }
        
        if userPaused {
            return .paused
        }
        
        if lastMove.isTimeout {
            return .timeout
        }
        
        if lastMove.isResign {
            return .resign
        }
        
        // Check for mate
        if board.findKing(board.playingSide).isUnderAttack {
            var isStuckInCheck = true
            if let allVariantBoards = board.createValidVariants(for: board.playingSide) {
                for boardVariant in allVariantBoards {
                    if let kingSquare = boardVariant.board.findOptionalKing(board.playingSide), !kingSquare.isUnderAttack {
                        isStuckInCheck = false
                    }
                }
            }
            if isStuckInCheck {
                return .mate
            }
        }

        // Does the active side have any valid moves?
        guard board.validVariantExists(for: board.playingSide) else {
            return .stalemate
        }
        
        // TODO: draws...
//            case drawByRepetition
//            case drawByMoves
//            case drawBecauseOfInsufficientMatingMaterial

        return .active

    }
}
