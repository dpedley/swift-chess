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
    func validAttacks() -> ChessRobotChoices {
        let filteredAttacks = self?.filter { variant in
            guard let move = variant.move else { return false }
            return !variant.board.squares[move.end].isEmpty
        }
        guard let attacks = filteredAttacks, attacks.count > 0 else { return nil }
        return attacks
    }
    func matingMoves() -> ChessRobotChoices {
        let filteredMoves = self?.filter { variant in
            guard variant.move != nil else { return false }
            return variant.board.isKingMated()
        }
        guard let matingMoves = filteredMoves, matingMoves.count > 0 else { return nil }
        return matingMoves
    }
    func saveMateMoves() -> ChessRobotChoices {
        // TODO
        return nil
    }
    func firstIfOnlyOne() -> Chess.SingleMoveVariant? {
        if let count = self?.count, count == 1 {
            return self?.first
        }
        return nil
    }
    func removingSacrifices() -> ChessRobotChoices {
        // TODO
        return self
    }
    func removingRiskyTakes(forSide side: Chess.Side) -> ChessRobotChoices {
        guard let potentials = self?.filter({ variant in
            // TODO update this
            // The spot we're going to is defended, it's not a good potential.
            // We only want to take if it's worth it.
            guard let move = variant.move else { return false }
            return variant.board.square(move.end, isDefendedBy: side.opposingSide) == false
        }), potentials.count>0 else { return nil }
        return potentials
    }
}
