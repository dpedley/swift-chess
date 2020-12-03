//
//  RandomBot.swift
//  
//
//  Created by Douglas Pedley on 11/26/20.
//

import Foundation
import SwiftUI

extension Chess.Robot {
    class RandomBot: Chess.Robot {
        override func evalutate(board: Chess.Board) -> Chess.Move? {
            // When in doubt, pick a random move
            return board.createValidVariants(for: side)?.randomElement()?.move
        }
    }

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

struct RandomBotGamePreview: PreviewProvider {
    static var store: ChessStore = {
        let white = Chess.Robot.GreedyBot(side: .white, stopAfterMove: 32)
        let black = Chess.Robot.GreedyBot(side: .black, stopAfterMove: 32)
        let store = ChessStore(initialGame: .init(white, against: black))
        store.game.userPaused = true
        store.game.setRobotPlaybackSpeed(3)
        return store
    }()
    static var previews: some View {
        GeometryReader { geometry in
            HStack {
                BoardView()
                    .environmentObject(store)
                VStack {
                    Button("Play") {
                        store.send(.startGame)
                    }
                    Button("Pause") {
                        store.send(.pauseGame)
                    }
                }
            }
        }
    }
}
