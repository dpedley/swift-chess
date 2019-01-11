//
//  Player.swift
//  LeelaChessZero
//
//  Created by Douglas Pedley on 1/6/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

typealias Chess_TurnCallback = (Chess.Move) -> Void

extension Chess {
    public class Player {
        let side: Side
        var timeLeft: TimeInterval? = nil
        var currentMoveStartTime: Date? = nil
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
        
        func timerRanOut() {
            fatalError("This method is meant to be overriden by subclasses")
        }
        
        func getBestMove(currentFEN: String, movesSoFar: [String], callback: @escaping Chess_TurnCallback) {
            fatalError("This method is meant to be overriden by subclasses")
        }
    }
}
