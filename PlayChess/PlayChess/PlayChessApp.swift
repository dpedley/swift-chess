//
//  PlayChessApp.swift
//  PlayChess
//
//  Created by Douglas Pedley on 12/9/20.
//

import SwiftUI
import Chess
import Logging

@main
struct PlayChessApp: App {
    let store: ChessStore =  {
        // Chess.log.logLevel = Logger.Level.info
        let store = ChessStore()
        return store
    }()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
