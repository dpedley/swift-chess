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
    class GreedyBot: RandomBot {
        override func worthyChoices(board: Chess.Board) -> [Chess.Move]? {
            guard let choices = board.createValidVariants(for: side) else { return nil }
            var theChosen: [Chess.Move] = []
            var bestGap: Double?
            for choice in choices {
                guard let move = choice.move else { continue }
                let pieceWeights = choice.board.pieceWeights()
                let choiceGap = pieceWeights.value(for: side) - pieceWeights.value(for: side.opposingSide)
                guard let currentBestGap = bestGap else {
                    // first one, it is worthy
                    bestGap = choiceGap
                    theChosen.append(move)
                    continue
                }
                guard choiceGap < currentBestGap else {
                    // our new chosen one
                    bestGap = choiceGap
                    theChosen.removeAll()
                    theChosen.append(move)
                    continue
                }
                if choiceGap==currentBestGap {
                    // Another worthy choice
                    theChosen.append(move)
                }
            }
            return theChosen.count > 0 ? theChosen : nil
        }
    }
}
