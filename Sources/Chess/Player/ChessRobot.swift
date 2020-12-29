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

extension Chess {
    /// A base robot, the evaluate is meant for subclasses
    open class Robot: Chess.Player, RoboticMoveDecider {
        /// How long to wait before starting to process the evaluation 0 = immediate
        public var responseDelay: TimeInterval = 0.0
        /// This is the last move that will be played.
        public var stopAfterMove: Int

        /// A few overrides from Chess.Player
        public override func isBot() -> Bool { return true }
        public override func prepareForGame() { }
        public override func timerRanOut() {}
        public override func iconName() -> String {
            switch side {
            case .black:
                return "ladybug.fill"
            case .white:
                return "ladybug"
            }
        }
        /// The main override from Chess.Player
        ///
        /// This is called by the game engine when this Robot Player should make a move.
        /// After a delay it evaulates the board that it was given.
        /// The move from the evaluation is sent to the ChessStore
        ///
        /// - Parameter game: The game that is being played. This is immutable. The ChessStore is used for updates.
        public override func turnUpdate(game: Chess.Game) {
            guard game.board.playingSide == side else {
                Chess.log.debug("Tried to turnUpdate when not my turn: \(side)")
                return
            }
            guard let delegate = game.delegate else {
                Chess.log.critical("Cannot run a game turn without a game delegate.")
                return
            }
            if stopAfterMove>0 && game.board.fullMoves >= stopAfterMove {
                Chess.log.debug("turnUpdate stopAfterMove: \(stopAfterMove)")
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
                        Chess.log.critical("Misconfigured board, bot cannot find it's own king.")
                        return
                    }
                    let move = self.side.resigns(king: square.position)
                    delegate.gameAction(.makeMove(move: move))
                    return
                }
                delegate.gameAction(.makeMove(move: move))
            }
        }
        public func validChoices(board: Chess.Board) -> ChessRobotChoices {
            board.createValidVariants(for: side)
        }
        /// Evaluate board for the optimal move
        ///
        /// - Parameter board: The board waiting for a move to be player by this bot.
        /// - Returns: Optional. The best move the bot found. If no move is returned, the bot resigns.
        public func evalutate(board: Chess.Board) -> Chess.Move? {
            var tmpBoard = Chess.Board(FEN: board.FEN)
            tmpBoard.playingSide = side
            return validChoices(board: tmpBoard)?.randomElement()?.move
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
