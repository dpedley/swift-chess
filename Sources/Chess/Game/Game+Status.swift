//
//  Game+Status.swift
//  
//
//  Created by Douglas Pedley on 11/27/20.
//

import Foundation

public extension Chess {
    enum GameStatus {
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

public extension Chess.Game {
    func computeGameStatus() -> Chess.GameStatus {
        guard let lastMove = board.lastMove else {
            if board.FEN == Chess.Board.startingFEN {
                return .notYetStarted
            }
            return .unknown
        }
        guard !userPaused else { return .paused }
        guard !lastMove.isTimeout else { return .timeout }
        guard !lastMove.isResign else { return .resign }
        guard !board.isKingMated() else { return .mate }
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
}
