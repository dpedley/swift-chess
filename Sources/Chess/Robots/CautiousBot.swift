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
        public override func iconName() -> String {
            switch side {
            case .black:
                return "tortoise.fill"
            case .white:
                return "tortoise"
            }
        }
        func filterTopPerformers(potentials: ChessRobotChoices) -> ChessRobotChoices {
            // If there is at most 1 potential move, we don't need to filter the list.
            if let only = potentials.firstIfOnlyOne() {
                return [only]
            }
            guard let sorted = potentials?.sorted(by: {
                $0.pieceWeights().value(for: side.opposingSide) < $1.pieceWeights().value(for: side.opposingSide)
            }) else { return nil }
            guard let firstValue = sorted.first?.pieceWeights().value(for: side.opposingSide) else { return nil }
            let filtered = sorted.filter { $0.pieceWeights().value(for: side.opposingSide) == firstValue }
            return filtered.count > 0 ? filtered : nil
        }
        public override func validChoices(board: Chess.Board) -> ChessRobotChoices {
            let choices = super.validChoices(board: board)
            if let matingChoices = choices.matingMoves() {
                return matingChoices
            }
            if let saveMateChoices = choices.saveMateMoves() {
                return saveMateChoices
            }
            let potentials = choices.removingSacrifices()
                                    .removingRiskyTakes()
            return filterTopPerformers(potentials: potentials)
        }
    }
}
