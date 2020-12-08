//
//  Chess.swift
//
//  Created by Douglas Pedley on 1/5/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

// Our namespace
public enum Chess { }

struct Chess_Preview: PreviewProvider {
    static var sampleStore: ChessStore = {
        let store = ChessStore(game: Chess.Game.sampleGame())
        store.game.userPaused = true
        store.game.setRobotPlaybackSpeed(0.5)
        return store
    }()
    static var previews: some View {
        GeometryReader { geometry in
            HStack {
                BoardView()
                    .environmentObject(sampleStore)
                VStack {
                    Button("Play") {
                        sampleStore.send(.startGame)
                    }
                    Button("Pause") {
                        sampleStore.send(.pauseGame)
                    }
                }
            }
        }
    }
}
