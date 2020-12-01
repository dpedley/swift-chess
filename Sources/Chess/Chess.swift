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
    static var previewCounter = 0
    static func chessSampleReducer(state: inout ChessState, action: ChessAction, environment: ChessEnvironment) -> AnyPublisher<ChessAction, Never>? {
        return nil
    }
    static var sampleStore: ChessStore = {
        let sampleGame = Chess.Game.sampleGame()
        let initialState = ChessState(player: sampleGame.white, opponent: sampleGame.black)
        let store = ChessStore(initialState: initialState,
                                       reducer: chessSampleReducer, environment: ChessEnvironment(target: .development))
        store.state.game.board.resetBoard()
        store.state.game.userPaused = true
        return store
    }()
    static var previews: some View {
        GeometryReader { geometry in
            HStack {
                BoardView()
                    .environmentObject(sampleStore)
                
                VStack {
                    Button("Play \(sampleStore.state.game.activePlayer?.lastName ?? "") next move") {
                        previewCounter += 1
                        sampleStore.state.game.nextTurn()
                    }
                    Text("Count: \(previewCounter)")
                }
            }
        }
    }
}
