//
//  ChessRobot.swift
//
//  A Chess Robot is a base class that negotiates the interations
//  between the game being played, and the ChessStore where the
//  Player's interactions are handled.
//
//  The main assumption is that subclasses will provide an evaluation
//  function. See: evalutate(board: Chess.Board) -> Chess.Move?
//
//  Created by Douglas Pedley on 11/26/20.
//

import Foundation

public extension Chess {
    /// A base robot, the evaluate is meant for subclasses
    class Robot: Chess.Player {
        /// How long to wait before starting to process the evaluation 0 = immediate
        var responseDelay: TimeInterval = 0.0
        /// This is the last move that will be played.
        var stopAfterMove: Int

        /// A few overrides from Chess.Player
        override func isBot() -> Bool { return true }
        override func prepareForGame() { }
        override func timerRanOut() {}
        /// The main override from Chess.Player
        ///
        /// This is called by the game engine when this Robot Player should make a move.
        /// After a delay it evaulates the board that it was given.
        /// The move from the evaluation is sent to the ChessStore
        ///
        /// - Parameter game: The game that is being played. This is immutable. The ChessStore is used for updates.
        override func turnUpdate(game: Chess.Game) {
            guard game.board.playingSide == side else { return }
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
        /// Evaluate board for the optimal move
        /// This is meant to be overriden by subclasses as the main game play
        /// interaction for chess robots.
        ///
        /// - Parameter board: The board waiting for a move to be player by this bot.
        /// - Returns: Optional. The best move the bot found. If no move is returned, the bot resigns.
        func evalutate(board: Chess.Board) -> Chess.Move? {
            fatalError("This is meant to be overridden.")
        }
        /// The required initializer for the Robot subclasses.
        /// let fred = RandomBot(.white)
        /// let jane = GreedyBot(.black)
        ///
        /// - Parameter side: The `Chess.Side` that this bot should play.
        /// - Parameter stopAfterMove: To keep things from running amok, you can set a move,
        /// and the bot will stop after that move has been performed.
        public init(side: Chess.Side, stopAfterMove: Int = 100) {
            self.stopAfterMove = stopAfterMove
            super.init(side: side, matchLength: nil)
        }
    }
}
