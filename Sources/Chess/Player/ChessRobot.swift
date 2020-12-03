//
//  File.swift
//  
//
//  Created by Douglas Pedley on 11/26/20.
//

import Foundation

protocol RobotPlayer {
    var responseDelay: TimeInterval { get set }
}

extension Chess {
    // A base robot, the evaluate is meant for subclasses
    class Robot: Chess.Player, RobotPlayer {
        var responseDelay: TimeInterval = 0.0
        var stopAfterMove: Int
        override func turnUpdate(game: Chess.Game) {
            guard let delegate = game.delegate else {
                fatalError("Cannot run a game turn without a game delegate.")
            }
            if stopAfterMove>0 && game.board.fullMoves >= stopAfterMove {
                return
            }
            let evaluteFEN = game.board.FEN
            weak var weakSelf = self
            weak var weakDelegate = delegate
            let sleepTime = responseDelay
            Thread.detachNewThread {
                if sleepTime>0 {
                    Thread.sleep(until: Date().addingTimeInterval(sleepTime))
                }
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
        required init(side: Chess.Side, stopAfterMove: Int = 100) {
            self.stopAfterMove = stopAfterMove
            super.init(side: side, matchLength: nil)
        }
    }
}
