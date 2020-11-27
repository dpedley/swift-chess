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
        
        override func getBestMove(currentFEN: String, movesSoFar: [String], callback: @escaping Chess_TurnCallback) {
            weak var weakSelf = self
            Thread.detachNewThread {
                if let responseDelay = weakSelf?.responseDelay {
                    Thread.sleep(forTimeInterval: responseDelay)
                }
                // Notice we don't strongify until after the sleep. Otherwise we'd be holding onto self
                guard let strongSelf = weakSelf else { return }
                guard strongSelf.currentMove<strongSelf.moveStrings.count else { return }
                let moveString = strongSelf.moveStrings[strongSelf.currentMove]
                guard let move = strongSelf.side.twoSquareMove(fromString: moveString) else {
                        return
                }
                strongSelf.currentMove += 1
                callback(move)
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
        
        override func getBestMove(currentFEN: String, movesSoFar: [String], callback: @escaping Chess_TurnCallback) {
            // TODO, this is probably where we serialize the state of the board for app restarts etc.
            if let move = moveAttempt {
                // Premove baby!
                moveAttempt = nil
                Thread.detachNewThread {
                    DispatchQueue.main.async {
                        Thread.sleep(forTimeInterval: HumanPlayer.minimalHumanTimeinterval)
                            callback(move)
                    }
                }
            } else {
                chessBestMoveCallback = callback
            }
        }
    }
}
