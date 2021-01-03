//
//  PlayerFactory.swift
//  
//
//  Created by Douglas Pedley on 12/30/20.
//

import SwiftUI

public extension Chess {
    struct PlayerFactorySettings {
        @AppStorage("defaultWhiteIndex", store: ChessEnvironment.defaults)
            public var white: Int = 0
        @AppStorage("defaultBlackIndex", store: ChessEnvironment.defaults)
            public var black: Int = 1
        public init() {}
    }
    typealias PlayerCreator = (Chess.Side) -> Chess.Player
    struct PlayerFactory {
        public var players: [PlayerCreator] = []
    }
    static var playerFactory: PlayerFactory = {
        var factory = PlayerFactory()
        factory.players.append { side in
            return Chess.HumanPlayer(side: side)
        }
        factory.players.append { side in
            let robot = Chess.Robot(side: side)
            robot.responseDelay = 1
            return robot
        }
        factory.players.append { side in
            let robot = Chess.Robot.GreedyBot(side: side)
            robot.responseDelay = 1
            return robot
        }
        factory.players.append { side in
            let robot = Chess.Robot.CautiousBot(side: side)
            robot.responseDelay = 1
            return robot
        }
        return factory
    }()
}
