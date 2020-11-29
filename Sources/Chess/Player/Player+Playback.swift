//
//  File.swift
//  
//
//  Created by Douglas Pedley on 11/26/20.
//

import Foundation

extension Chess {
    public class PlaybackPlayer: Player {
        var moveStrings: [String] = []
        var currentMove = 0
        let responseDelay: TimeInterval
        required init(firstName: String, lastName: String, side: Side, moves: [String], responseDelay: TimeInterval) {
            self.responseDelay = responseDelay
            moveStrings.append(contentsOf: moves)
            super.init(side: side, matchLength: nil)
            self.firstName = firstName
            self.lastName = lastName
        }
        
        override func isBot() -> Bool {
            return true
        }
        
        override func prepareForGame() {
            currentMove = 0
        }
        
        override func turnUpdate(game: Chess.Game) {
            // This bot only acts on it's own turn, no eval during opponents move time
            guard game.board.playingSide == side else { return }
            weak var weakSelf = self
            Thread.detachNewThread {
                if let responseDelay = weakSelf?.responseDelay {
                    Thread.sleep(forTimeInterval: responseDelay)
                }
                // Notice we don't strongify until after the sleep. Otherwise we'd be holding onto self
                guard let self = weakSelf else { return }
                guard self.currentMove<self.moveStrings.count else { return }
                let moveString = self.moveStrings[self.currentMove]
                guard let move = self.side.twoSquareMove(fromString: moveString) else {
                        return
                }
                
                // Make yer move.
                game.execute(move: move)
                
                // If the move worked, we should see it is not the opponents turn
                if game.board.playingSide == self.side.opposingSide {
                    // It worked, let's update our move index
                    self.currentMove += 1
                }
            }
        }
    }
}

extension Chess {
    public class HumanPlayer: Player {
        static let minimalHumanTimeinterval: TimeInterval = 0.1
        public var chessBestMoveCallback: Chess_TurnCallback?
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
        override func isBot() -> Bool {
            return false
        }
        
        override func prepareForGame() {
            // Washes hands
        }
        
        override func timerRanOut() {
            // TODO message human that the game is over.
        }
        
        override func turnUpdate(game: Chess.Game) {
            // TODO, this is probably where we serialize the state of the board for app restarts etc.
            if let move = moveAttempt {
                // Premove baby!
                moveAttempt = nil
                Thread.detachNewThread {
                    DispatchQueue.main.async {
                        Thread.sleep(forTimeInterval: HumanPlayer.minimalHumanTimeinterval)
                        game.execute(move: move)
                    }
                }
            } else {
                chessBestMoveCallback = { move in
                    game.execute(move: move)
                }
            }
        }
    }
}
