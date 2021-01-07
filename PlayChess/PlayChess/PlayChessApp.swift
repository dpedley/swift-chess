//
//  PlayChessApp.swift
//  PlayChess
//
//  Created by Douglas Pedley on 12/9/20.
//

import SwiftUI
import Combine
import Chess
import Logging

@main
struct PlayChessApp: App {
    let store: ChessStore = {
        Chess.log.logLevel = Logger.Level.error
        let players = Chess.PlayerFactorySettings()
        let white = Chess.playerFactory.players[players.white](.white)
        let black = Chess.playerFactory.players[players.black](.black)
        let store = ChessStore(game: Chess.Game(white, against: black))
        store.game.setRobotPlaybackSpeed(1)
        store.environment.target = .production
        return store
    }()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
