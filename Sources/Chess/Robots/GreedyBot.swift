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
        public override func iconName() -> String {
            switch side {
            case .black:
                return "hare.fill"
            case .white:
                return "hare"
            }
        }
        public override func validChoices(board: Chess.Board) -> ChessRobotChoices {
            let choices = super.validChoices(board: board)
            let attacks = choices.filterMatingMoves()
                                 .preferAttacks()
                                 .filterTopWeightClass()
            return attacks
        }
    }
}
