//
//  File.swift
//  
//
//  Created by Douglas Pedley on 11/26/20.
//

import Foundation

// A simplified robot protocol to enable some low level bots
protocol ChessRobot {
    func evalutate(board: Chess.Board) -> Chess.Move?
}

extension ChessRobot where Self: Chess.Player {
    func isBot() -> Bool { return true }
    func prepareForGame() { }
    func timerRanOut() { }
    func getBestMove(currentFEN: String, movesSoFar: [String], callback: @escaping Chess_TurnCallback) {
        weak var weakSelf = self
        Thread.detachNewThread {
            guard let self = weakSelf else { return }
            guard let move = self.evalutate(board: .init(FEN: currentFEN)) else {
                guard let king = self.board?.squareForActiveKing.position else {
                    fatalError("Misconfigured board, bot cannot find it's own king.")
                }
                callback(self.side.resigns(king: king))
                return
            }
            callback(move)
        }

    }
}
