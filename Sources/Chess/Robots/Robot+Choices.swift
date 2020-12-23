//
//  Robot+Choices.swift
//  
//
//  Created by Douglas Pedley on 12/10/20.
//

import Foundation

public typealias ChessRobotChoices = [Chess.SingleMoveVariant]?

public protocol RoboticMoveDecider {
    func validChoices(board: Chess.Board) -> ChessRobotChoices
    func evalutate(board: Chess.Board) -> Chess.Move?
}

public extension ChessRobotChoices {
    func firstIfOnlyOne() -> ChessRobotChoices {
        if let count = self?.count, count == 1 {
            return self
        }
        return nil
    }
    func preferAttacks() -> ChessRobotChoices {
        if let only = firstIfOnlyOne() { return only }
        let filteredAttacks = self?.filter { variant in
            guard let move = variant.move else { return false }
            return !variant.board.squares[move.end].isEmpty
        }
        guard let attacks = filteredAttacks, attacks.count > 0 else {
            // There were no attacks, so we return ourselves unfiltered
            return self
        }
        return attacks
    }
    func filterMatingMoves() -> ChessRobotChoices {
        if let only = firstIfOnlyOne() { return only }
        let filteredMoves = self?.filter { variant in
            guard variant.move != nil else { return false }
            return variant.board.isKingMated()
        }
        guard let matingMoves = filteredMoves, matingMoves.count > 0 else {
            // There were no mating moves, so we return ourselves unfiltered
            return self
        }
        return matingMoves
    }
    func filterMatingSaves() -> ChessRobotChoices {
        if let only = firstIfOnlyOne() { return only }
        // Avoid the moves that result in ourselves being mated
        let filteredMoves = self?.filter { variant in
            guard let move = variant.move else { return false }
            // In this variant, we want to see if it produces any variants that
            // can checkmate us
            let sideToSave = move.side
            let sideTryingToMate = sideToSave.opposingSide
            let oppTries = variant.board.createValidVariants(for: sideTryingToMate)
            let oppMoves = oppTries?.filter { oppVariant in
                guard oppVariant.move != nil else { return false }
                return oppVariant.board.isKingMated()
            }
            guard let oppCount = oppMoves?.count, oppCount > 0 else {
                // No opponent mating moves found the variant need not be filtered
                return true
            }
            return false
        }
        guard let mateFreeCount = filteredMoves?.count, mateFreeCount > 0 else {
            // There were no mating moves, so we return ourselves unfiltered
            return self
        }
        return filteredMoves
    }
    func removingRiskyTakes() -> ChessRobotChoices {
        if let only = firstIfOnlyOne() { return only }
        let riskFree = self?.filter { variant in
            // TODO update this
            // The spot we're going to is defended, it's not a good potential.
            // We only want to take if it's a capture that is worth it.
            guard let move = variant.move else { return false }
            guard variant.board.square(move.end, isDefendedBy: move.side.opposingSide) else {
                // The spot isn't defended, it isn't risky, it stays in
                return true
            }
            // The spot is defended, we only want to move there if it captures a piece worth more than we lose.
            let findPiecesBoard = Chess.Board(FEN: variant.originalFEN)
            // These guards shouldn't fail, the move was already vetted.
            guard let pieceLoss = findPiecesBoard.squares[move.start].piece,
                  let pieceGain = findPiecesBoard.squares[move.end].piece else { return false }
            if pieceLoss.weight < pieceGain.weight {
                // Worth it
                return true
            }
            return false
        }
        guard let riskFreeCount = riskFree?.count, riskFreeCount > 0 else {
            // There were no move that were risk free, so we return ourselves unfiltered
            return self
        }
        return riskFree
    }
    func filterTopWeightClass() -> ChessRobotChoices {
        // If there is at most 1 potential move, we don't need to filter the list.
        if let only = firstIfOnlyOne() { return only }
        guard let side = self?.first?.move?.side else {
            // We need to know the side in order to filter, so we'll return unfiltered
            return self
        }
        guard let sorted = self?.sorted(by: {
            $0.pieceWeights().value(for: side.opposingSide) < $1.pieceWeights().value(for: side.opposingSide)
        }) else { return nil }
        guard let firstValue = sorted.first?.pieceWeights().value(for: side.opposingSide) else { return nil }
        let filtered = sorted.filter { $0.pieceWeights().value(for: side.opposingSide) == firstValue }
        return filtered.count > 0 ? filtered : nil
    }
}
