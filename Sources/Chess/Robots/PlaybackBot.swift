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
    public class PlaybackBot: Chess.Robot {
        var moves: [Chess.Move] = []
        var currentMove = 0
        required init(firstName: String? = nil, lastName: String? = nil, side: Chess.Side, moves: [Chess.Move]) {
            super.init(side: side)
            self.responseDelay = responseDelay
            self.moves.append(contentsOf: moves)
            self.firstName = firstName ?? Chess.Robot.randomFirstName()
            self.lastName = lastName ?? side.description.capitalized
        }
        convenience init(firstName: String? = nil, lastName: String? = nil, side: Chess.Side, moveStrings: [String]) {
            self.init(firstName: firstName, lastName: lastName, side: side, moves: moveStrings.compactMap({ side.twoSquareMove(fromString: $0) }))
        }
        override func evalutate(board: Chess.Board) -> Chess.Move? {
            guard self.currentMove<self.moves.count else {
                return nil
            }
            let move = self.moves[self.currentMove]
            self.currentMove += 1
            return move
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
