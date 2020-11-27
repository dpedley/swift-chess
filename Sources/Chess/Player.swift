//
//  Player.swift
//
//  Created by Douglas Pedley on 1/6/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

public typealias Chess_TurnCallback = (Chess.Move) -> Void

extension Chess {
    public class Player {
        let side: Side
        var timeLeft: TimeInterval? = nil
        var currentMoveStartTime: Date? = nil
        var firstName: String? = nil
        var lastName: String? = nil
        var pgnName: String {
            guard let firstName = firstName, let lastName = lastName else {
                return "??"
            }
            return "\(lastName), \(firstName)"
        }
        weak var board: Chess_PieceCoordinating?
        public init(side: Side, matchLength: TimeInterval?) {
            self.side = side
            self.timeLeft = matchLength
        }
        
        func startTurn(currentFEN: String, movesSoFar: [String], callback: @escaping Chess_TurnCallback)  {
            defer {
                // Start the timer as we leave here.
                currentMoveStartTime = Date()
            }
            
            weak var weakSelf = self
            if let timeLeftAtMoveStart = timeLeft {
                let timeoutTimer = Timer.scheduledTimer(withTimeInterval: timeLeftAtMoveStart, repeats: false) { timer in
                    guard let strongSelf = weakSelf, let board = strongSelf.board else { return }
                    strongSelf.timerRanOut()
                    // For a timeout we use the king's position as the move's start and end.
                    let kingPosition = board.squareForActiveKing
                    callback(Move(side: board.playingSide, start: kingPosition.position, end: Position.timedOutPosition, ponderTime: timeLeftAtMoveStart))
                }
                self.getBestMove(currentFEN: currentFEN, movesSoFar: movesSoFar) { move in
                    guard let strongSelf = weakSelf, let board = strongSelf.board else { return }
                    
                    // The player made a move, stop the timer and pass the move up the chain.
                    timeoutTimer.invalidate()
                    guard let startTime = strongSelf.currentMoveStartTime else {
                        // This shouldn't happen, maybe a race condition? let's have the timeout win.
                        callback(Move(side: board.playingSide, start: move.start, end: Position.timedOutPosition, ponderTime: timeLeftAtMoveStart))
                        return
                    }
                    strongSelf.timeLeft = timeLeftAtMoveStart - startTime.timeIntervalSinceNow
                    strongSelf.currentMoveStartTime = nil
                    callback(move)
                }                
            }
        }
        
        func prepareForGame() {
            fatalError("This method is meant to be overriden by subclasses")
        }
        
        func isBot() -> Bool {
            fatalError("This method is meant to be overriden by subclasses")
        }
        
        func timerRanOut() {
            fatalError("This method is meant to be overriden by subclasses")
        }
        
        func getBestMove(currentFEN: String, movesSoFar: [String], callback: @escaping Chess_TurnCallback) {
            fatalError("This method is meant to be overriden by subclasses")
        }
    }
}


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
