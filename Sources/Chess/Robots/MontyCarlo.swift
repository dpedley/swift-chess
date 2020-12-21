//
//  MontyCarlo.swift
//  
//
//  Created by Douglas Pedley on 12/21/20.
//

import Foundation
import GameplayKit

public extension Chess.Robot {
    /// A monty carlo strategist using GKGameModel
    class MontyCarloBot: Chess.Player {
        var board = Chess.BoardVariant(originalFEN: Chess.Board.startingFEN, deepVariant: true)
        let strategist: GKMonteCarloStrategist = {
            let strategist = GKMonteCarloStrategist()
            strategist.budget = 15
            strategist.explorationParameter = 4
            return strategist
        }()
        /// A few overrides from Chess.Player
        public override func isBot() -> Bool { return true }
        public override func prepareForGame() { }
        public override func timerRanOut() {}
        public override func iconName() -> String {
            switch side {
            case .black:
                return "frame.fill"
            case .white:
                return "frame"
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
            board = Chess.BoardVariant(originalFEN: game.board.FEN, deepVariant: true)
            strategist.gameModel = board
            strategist.randomSource = GKARC4RandomSource()
            weak var weakSelf = self
            weak var weakDelegate = delegate
            Thread.detachNewThread {
                guard let self = weakSelf, let delegate = weakDelegate else { return }
                guard let strategy = self.strategist.bestMoveForActivePlayer() else {
                    let square = game.board.squareForActiveKing
                    guard square.piece?.side == self.side else {
                        Chess.log.critical("Misconfigured board, bot cannot find it's own king.")
                        return
                    }
                    let move = self.side.resigns(king: square.position)
                    delegate.gameAction(.makeMove(move: move))
                    return
                }
                guard let move = (strategy as? Chess.GameModelUpdate)?.move else {
                    Chess.log.critical("Misconfigured strategist, model update not validz.")
                    return
                }
                delegate.gameAction(.makeMove(move: move))
            }
        }
        public init(side: Chess.Side) {
            super.init(side: side, matchLength: nil)
        }
    }
}
