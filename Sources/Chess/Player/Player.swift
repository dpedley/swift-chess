//
//  Player.swift
//
//  Created by Douglas Pedley on 1/6/19.
//

import Foundation

public typealias ChessTurnCallback = (Chess.Move) -> Void

extension Chess {
    open class Player {
        public var side: Side
        public var timeLeft: TimeInterval?
        public var currentMoveStartTime: Date?
        public var firstName: String?
        public var lastName: String?
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
        public func prepareForGame() {
            fatalError("This method is meant to be overriden by subclasses")
        }
        public func isBot() -> Bool {
            fatalError("This method is meant to be overriden by subclasses")
        }
        public func timerRanOut() {
            fatalError("This method is meant to be overriden by subclasses")
        }
        public func turnUpdate(game: Chess.Game) {
            fatalError("This method is meant to be overriden by subclasses")
        }
        public func iconName() -> String {
            switch side {
            case .black:
                return "crown.fill"
            case .white:
                return "crown"
            }
        }
        public func menuName() -> String {
            if self is Chess.Robot.CautiousBot {
                return "CautiousBot"
            }
            if self is Chess.Robot.GreedyBot {
                return "GreedyBot"
            }
            if self is Chess.Robot.MindyMaxBot {
                return "MindyMax"
            }
            if self is Chess.Robot.MontyCarloBot {
                return "MontyCarlo"
            }
            if self is Chess.Robot {
                return "RandomBot"
            }
            return firstName ?? lastName ?? "You"
        }
    }
}
