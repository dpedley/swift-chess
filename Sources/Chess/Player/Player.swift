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
        public init(side: Side, matchLength: TimeInterval? = nil) {
            self.side = side
            self.timeLeft = matchLength
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
        
        func turnUpdate(game: Chess.Game) {
            fatalError("This method is meant to be overriden by subclasses")
        }
    }
}
