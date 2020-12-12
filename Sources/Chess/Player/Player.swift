//
//  Player.swift
//
//  Created by Douglas Pedley on 1/6/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

public typealias ChessTurnCallback = (Chess.Move) -> Void

public extension Chess {
    class Player {
        let side: Side
        var timeLeft: TimeInterval?
        var currentMoveStartTime: Date?
        var firstName: String?
        var lastName: String?
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
