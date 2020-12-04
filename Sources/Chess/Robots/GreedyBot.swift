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

extension Chess.Robot {
    class GreedyBot: RandomBot {
        let noBackupMove = Double.nan
        override func evalutate(board: Chess.Board) -> Chess.Move? {
            guard let choices = board.createValidVariants(for: side) else { return nil }
            let weights = board.pieceWeights()
            var bestChoice: Chess.SingleMoveVariant?
            var bestGap = weights.value(for: side) - weights.value(for: side.opposingSide)
            var backupGap: Double?
            for choice in choices {
                let pieceWeights = choice.board.pieceWeights()
                let choiceGap = pieceWeights.value(for: side) - pieceWeights.value(for: side.opposingSide)
                guard choiceGap < bestGap else {
                    // our new best
                    bestGap = choiceGap
                    bestChoice = choice
                    // Backup no longer needed.
                    backupGap = noBackupMove
                    continue
                }
                guard let currentBackupGap = backupGap else {
                    // This is our first backup
                    backupGap = choiceGap
                    bestChoice = choice
                    continue
                }
                guard currentBackupGap != noBackupMove else {
                    // No backup needed
                    continue
                }
                // We still need a backup move, and it isn't our first
                guard choiceGap > currentBackupGap else {
                    // This choice isn't better than our current backup.
                    continue
                }
                // It will do for now
                backupGap = choiceGap
                bestChoice = choice
            }
            return bestChoice?.move
        }
    }
}

