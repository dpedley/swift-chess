//
//  MindyMaxBot.swift
//  
//
//  Created by Douglas Pedley on 12/21/20.
//

import Foundation
import GameplayKit

public extension Chess.Robot {
    /// A min / max strategist using GKGameModel
    class MindyMaxBot: Chess.Player {
        var board = Chess.BoardVariant(originalFEN: Chess.Board.startingFEN)
        let strategist: GKMinmaxStrategist
        /// A few overrides from Chess.Player
        public override func isBot() -> Bool { return true }
        public override func prepareForGame() { }
        public override func timerRanOut() {}
        public override func iconName() -> String {
            switch side {
            case .black:
                return "bolt.fill"
            case .white:
                return "bolt"
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
            board = Chess.BoardVariant(originalFEN: game.board.FEN)
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
                guard let variant = (strategy as? Chess.GameModelUpdate)?.variant,
                      let move = variant.changes.last else {
                    Chess.log.critical("Misconfigured strategist, model update not valid.")
                    return
                }
                delegate.gameAction(.makeMove(move: move))
            }
        }
        public init(side: Chess.Side, maxDepth: Int = 2) {
            let mixmax = GKMinmaxStrategist()
            mixmax.maxLookAheadDepth = maxDepth
            self.strategist = mixmax
            super.init(side: side, matchLength: nil)
        }
    }
}
