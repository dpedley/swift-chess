//
//  RandomBot.swift
//  
//
//  Created by Douglas Pedley on 11/26/20.
//

import Foundation

class RandomBot: Chess.Player, ChessRobot {
    func evalutate(board: Chess.Board) -> Chess.Move? {
        // When in doubt, pick a random move
        return board.createValidVariants(for: side)?.randomElement()?.move
    }
}

class GreedyBot: RandomBot {
    override func evalutate(board: Chess.Board) -> Chess.Move? {
        guard let choices = board.createValidVariants(for: side) else { return nil }
        let currentWeights = board.pieceWeights
        var bestChoice: Chess.SingleMoveVariant?
        var bestGap = currentWeights.value(for: side) - currentWeights.value(for: side.opposingSide)
        for choice in choices {
            let pieceWeights = choice.board.pieceWeights
            let choiceGap = pieceWeights.value(for: side) - pieceWeights.value(for: side.opposingSide)
            if choiceGap > bestGap {
                bestGap = choiceGap
                bestChoice = choice
            }
        }
        return bestChoice?.move
    }
}
