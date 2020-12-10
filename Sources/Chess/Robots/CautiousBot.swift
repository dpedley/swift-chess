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
    class CautiousBot: RandomBot {
        public override func worthyChoices(board: Chess.Board) -> [Chess.Move]? {
            guard let choices = board.createValidVariants(for: side) else { return nil }
            var potentials: [Chess.SingleMoveVariant] = []
            for choice in choices {
                guard let move = choice.move else { continue }
                if !board.squares[move.end].isEmpty,
                   choice.board.square(move.end, isDefendedBy: side.opposingSide) {
                    // The piece we want to take is defended... be cautious.
                    continue
                }
                potentials.append(choice)
            }
            // If there is at most 1 potential move, we don't need to filter the list.
            guard potentials.count > 1 else {
                guard let move = potentials.first?.move else { return nil }
                return [move]
            }
            let sorted = potentials.sorted {
                $0.pieceWeights().value(for: side.opposingSide) < $1.pieceWeights().value(for: side.opposingSide)
            }
            guard let firstValue = sorted.first?.pieceWeights().value(for: side.opposingSide) else { return nil }
            let filtered = sorted.filter { $0.pieceWeights().value(for: side.opposingSide) == firstValue }
            let theChosen = filtered.compactMap { $0.move }
            return theChosen.count > 0 ? theChosen : nil
        }
    }
}
