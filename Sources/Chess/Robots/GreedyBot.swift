//
//  GreedyBot.swift
//
// As the name implies, greedy bot looks to grab pieces
// at any opportunity. It takes risks without looking at
// the consequences.
//
//  Created by Douglas Pedley on 12/3/20.
//

import Foundation

public extension Chess.Robot {
    class GreedyBot: Chess.Robot {
        func bestAttacks(attacks: [Chess.SingleMoveVariant]) -> [Chess.SingleMoveVariant] {
            // When you're greedy, the best attack have the highest piece value change
            let sortedAttacks = attacks.sorted {
                return $0.pieceWeights().value(for: side.opposingSide) <
                    $1.pieceWeights().value(for: side.opposingSide)
            }
            let bestWeight = sortedAttacks.first?.pieceWeights().value(for: side.opposingSide) ?? 0
            return sortedAttacks.filter { $0.pieceWeights().value(for: side.opposingSide) == bestWeight }
        }
        public override func iconName() -> String {
            switch side {
            case .black:
                return "hare"
            case .white:
                return "hare.fill"
            }
        }
        public override func validChoices(board: Chess.Board) -> [Chess.SingleMoveVariant]? {
            guard let choices = super.validChoices(board: board) else { return nil }
            if let matingChoices = matingMoves(choices: choices) {
                return matingChoices
            }
            guard let attacks = validAttacks(choices: choices) else {
                // If we can't attack, who cares.
                return choices
            }
            return bestAttacks(attacks: attacks)
        }
    }
}
