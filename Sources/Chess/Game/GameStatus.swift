//
//  GameStatus.swift
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
        case paused
        case mate
        case resign
        case timeout
        case drawByRepetition
        case drawByMoves
        case drawBecauseOfInsufficientMatingMaterial
        case stalemate
        public var gameEnder: String? {
            switch self {
            case .unknown, .notYetStarted, .active, .paused:
                return nil
            case .mate:
                return "Checkmate"
            case .resign:
                return "Resign"
            case .stalemate:
                return "Stalemate"
            case .drawByMoves:
                return "Move limit reached"
            case .drawByRepetition:
                return "Move repetition"
            case .drawBecauseOfInsufficientMatingMaterial:
                return "No mating material"
            case .timeout:
                return "Timed out"
            }
        }
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
        guard !userPaused else { return .paused }
        return .active
    }
}
