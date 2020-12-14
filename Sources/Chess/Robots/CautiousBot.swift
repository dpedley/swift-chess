//
//  CautiousBot.swift
//  
// As the name implies, cautious bot will first look at
// the consequences to an tries to find moves that aren't risky
//
//  Created by Douglas Pedley on 12/5/20.
//

import Foundation

public extension Chess.Robot {
    class CautiousBot: Chess.Robot {
        public override func validChoices(board: Chess.Board) -> [Chess.SingleMoveVariant]? {
            guard let choices = super.validChoices(board: board) else { return nil }
            if let matingChoices = matingMoves(choices: choices) {
                return matingChoices
            }

            var potentials: [Chess.SingleMoveVariant] = []
            for choice in choices {
                guard let move = choice.move else { continue }
                if choice.board.square(move.end, isDefendedBy: side.opposingSide) {
                    // The spot we're going to is defended, it's not a good potential.
                    continue
                }
                potentials.append(choice)
            }
            // If there is at most 1 potential move, we don't need to filter the list.
            guard potentials.count > 1 else {
                guard let move = potentials.first else { return nil }
                return [move]
            }
            let sorted = potentials.sorted {
                $0.pieceWeights().value(for: side.opposingSide) < $1.pieceWeights().value(for: side.opposingSide)
            }
            guard let firstValue = sorted.first?.pieceWeights().value(for: side.opposingSide) else { return nil }
            let filtered = sorted.filter { $0.pieceWeights().value(for: side.opposingSide) == firstValue }
            return filtered.count > 0 ? filtered : nil
        }
    }
}
