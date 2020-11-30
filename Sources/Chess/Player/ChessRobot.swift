//
//  File.swift
//  
//
//  Created by Douglas Pedley on 11/26/20.
//

import Foundation

extension Chess {
    // A base robot, the evaluate is meant for subclasses
    class Robot: Chess.Player {
        override func turnUpdate(game: Chess.Game) {
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
        func evalutate(board: Chess.Board) -> Chess.Move? {
            fatalError("This is meant to be overridden.")
        }
        override func isBot() -> Bool { return true }
        override func prepareForGame() { }
        override func timerRanOut() {}
    }
}
