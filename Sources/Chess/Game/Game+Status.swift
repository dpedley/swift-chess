//
//  Game+Status.swift
//  
//
//  Created by Douglas Pedley on 11/27/20.
//

import Foundation

extension Chess {
    public enum GameStatus {
        case unknown
        case notYetStarted
        case active
        case mate
        case resign
        case timeout
        case drawByRepetition
        case drawByMoves
        case drawBecauseOfInsufficientMatingMaterial
        case stalemate
        case paused
    }
}

extension Chess.Game {
    // swiftlint:disable cyclomatic_complexity
    mutating func status() -> Chess.GameStatus {
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
        if board.square(board.squareForActiveKing.position, canBeAttackedBy: board.playingSide) {
            var isStuckInCheck = true
            if let allVariantBoards = board.createValidVariants(for: board.playingSide) {
                for boardVariant in allVariantBoards {
                    if let kingSquare = boardVariant.board.findOptionalKing(board.playingSide),
                       boardVariant.board.square(kingSquare.position, canBeAttackedBy: board.playingSide) {
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
        // STILL UNDONE: draws...
//            case drawByRepetition
//            case drawByMoves
//            case drawBecauseOfInsufficientMatingMaterial
        return .active

    }
    // swiftlint:enable cyclomatic_complexity
}
