//
//  File.swift
//  
//
//  Created by Douglas Pedley on 12/3/20.
//

import Foundation
import SwiftUI

struct RobotGamePreview: PreviewProvider {
    static var store: ChessStore = {
        let white = Chess.Robot.GreedyBot(side: .white, stopAfterMove: 32)
        let black = Chess.Robot.CautiousBot(side: .black, stopAfterMove: 32)
        let store = ChessStore(game: .init(white, against: black))
        store.game.userPaused = true
        store.game.setRobotPlaybackSpeed(1)
        return store
    }()
    static var previews: some View {
        GeometryReader { geometry in
            HStack {
                BoardView()
                    .environmentObject(store)
                VStack {
                    Button("Play") {
                        store.send(.startGame)
                    }
                    Button("Pause") {
                        store.send(.pauseGame)
                    }
                }
            }
        }
    }
}

