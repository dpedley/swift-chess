//
//  File.swift
//  
//
//  Created by Douglas Pedley on 12/1/20.
//

import Foundation

extension Chess {
    public class HumanPlayer: Player {
        static let minimalHumanTimeinterval: TimeInterval = 0.1
        public var chessBestMoveCallback: ChessTurnCallback?
        public var initialPositionTapped: Chess.Position?
        public var moveAttempt: Chess.Move? {
            didSet {
                if let move = moveAttempt, let callback = chessBestMoveCallback {
                    callback(move)
                    moveAttempt = nil
                    initialPositionTapped = nil
                }
            }
        }
        override func isBot() -> Bool { return false }
        override func turnUpdate(game: Chess.Game) {
            if let move = moveAttempt {
                // Premove baby!
                moveAttempt = nil
                game.delegate?.send(.makeMove(move: move))
            } else {
                weak var weakDelegate = game.delegate
                chessBestMoveCallback = { move in
                    guard let delegate = weakDelegate else { return }
                    delegate.send(.makeMove(move: move))
                }
            }
        }
        override func prepareForGame() {
            // Washes hands
        }
        override func timerRanOut() {
            // This is where we will message the human that the game is over.
        }
    }
}
