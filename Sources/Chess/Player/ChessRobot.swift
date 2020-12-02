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
            guard let delegate = game.delegate else {
                fatalError("Cannot run a game turn without a game delegate.")
            }
            let evaluteFEN = game.board.FEN
            weak var weakSelf = self
            weak var weakDelegate = delegate
            Thread.detachNewThread {
                guard let self = weakSelf, let delegate = weakDelegate else { return }
                let board = Chess.Board(FEN: evaluteFEN)
                guard let move = self.evalutate(board: board) else {
                    let square = game.board.squareForActiveKing
                    guard square.piece?.side == self.side else {
                        fatalError("Misconfigured board, bot cannot find it's own king.")
                    }
                    let move = self.side.resigns(king: square.position)
                    delegate.send(.makeMove(move: move))
                    return
                }
                delegate.send(.makeMove(move: move))
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
