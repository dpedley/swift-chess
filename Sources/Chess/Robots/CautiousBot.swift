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
        public override func validChoices(board: Chess.Board) -> ChessRobotChoices {
            let choices = super.validChoices(board: board)
            let potentials = choices.filterMatingMoves()
                                    .filterMatingSaves()
                                    .removingRiskyTakes()
                                    .filterTopWeightClass()
            return potentials
        }
    }
}
