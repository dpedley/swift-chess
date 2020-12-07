//
//  CautiousBot.swift
//  
// As the name implies, cautious bot will first look at
// the consequences to an tries to find moves that aren't risky
//
//  Created by Douglas Pedley on 12/5/20.
//

import Foundation

extension Chess.Robot {
    class CautiousBot: RandomBot {
        override func worthyChoices(board: Chess.Board) -> [Chess.Move]? {
            guard let choices = board.createValidVariants(for: side) else { return nil }
            var theChosen: [Chess.Move] = []
            var bestGap: Double?
            for choice in choices {
                guard let move = choice.move else { continue }
                guard let responses = choice.board.createValidVariants(for: side.opposingSide),
                      let bestResponse = responses.sorted(by: {
                                                            $0.pieceWeights.value(for: side.opposingSide) >
                                                                $1.pieceWeights.value(for: side.opposingSide) } ).first else {
                    continue
                }
                
                let choiceGap = bestResponse.pieceWeights.value(for: side) - bestResponse.pieceWeights.value(for: side.opposingSide)
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

