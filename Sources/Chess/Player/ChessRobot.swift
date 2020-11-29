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
    func turnUpdate(game: Chess.Game) {
        weak var weakSelf = self
        Thread.detachNewThread {
            guard let self = weakSelf else { return }
            guard let move = self.evalutate(board: game.board) else {
                let square = game.board.squareForActiveKing
                guard square.piece?.side == self.side else {
                    fatalError("Misconfigured board, bot cannot find it's own king.")
                }
                game.execute(move: self.side.resigns(king: square.position))
                return
            }
            game.execute(move: move)
        }
    }
}
