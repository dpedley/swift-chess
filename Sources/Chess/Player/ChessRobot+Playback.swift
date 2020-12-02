//
//  PlaybackBot.swift
//
//  A chess robot meant to repeat the set of moves it was given.
//  This would be useful or reviewing PGNs for examples.
//
//  Created by Douglas Pedley on 11/26/20.
//

import Foundation

extension Chess.Robot {
    static let playbackDelay: TimeInterval = 0.1
    public class PlaybackBot: Chess.Player {
        var moves: [Chess.Move] = []
        var currentMove = 0
        let responseDelay: TimeInterval
        required init(firstName: String? = nil, lastName: String? = nil, side: Chess.Side, moves: [Chess.Move], responseDelay: TimeInterval = playbackDelay) {
            self.responseDelay = responseDelay
            self.moves.append(contentsOf: moves)
            super.init(side: side, matchLength: nil)
            self.firstName = firstName ?? randomFirstName()
            self.lastName = lastName ?? side.description.capitalized
        }
        convenience init(firstName: String? = nil, lastName: String? = nil, side: Chess.Side, moveStrings: [String], responseDelay: TimeInterval = playbackDelay) {
            self.init(firstName: firstName, lastName: lastName, side: side, moves: moveStrings.compactMap({ side.twoSquareMove(fromString: $0) }), responseDelay: responseDelay)
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
            guard let delegate = game.delegate else {
                fatalError("Cannot run a game turn without a game delegate.")
            }
            weak var weakSelf = self
            weak var weakDelegate = delegate
            Thread.detachNewThread {
                if let responseDelay = weakSelf?.responseDelay {
                    Thread.sleep(forTimeInterval: responseDelay)
                }
                // Notice we don't strongify until after the sleep. Otherwise we'd be holding onto self
                guard let self = weakSelf, let delegate = weakDelegate,
                      self.currentMove<self.moves.count else { return }
                let move = self.moves[self.currentMove]
                
                // Make yer move.
                delegate.send(.makeMove(move: move))
                
                // Let's update our move index
                self.currentMove += 1
            }
        }
    }
}

extension Chess.Robot {
    static func playback(moves: [Chess.Move]) -> Chess.Game {
        let white = PlaybackBot(side: .white, moves: moves.filter({ $0.side == .white }))
        let black = PlaybackBot(side: .black, moves: moves.filter({ $0.side == .black }))
        return Chess.Game(white, against: black)
    }
}
