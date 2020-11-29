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
    static func chessSampleReducer(state: inout ChessState, action: ChessAction, environment: ChessEnvironment) -> AnyPublisher<ChessAction, Never>? {
        return nil
    }
    static var sampleStore: ChessStore = {
        let sampleGame = Chess.Game.sampleGame()
        let initialState = ChessState(player: sampleGame.white, opponent: sampleGame.black)
        let store = ChessStore(initialState: initialState,
                                       reducer: previewChessReducer, environment: ChessEnvironment(target: .development))
        store.state.game.board.resetBoard()
        return store
    }()
    static var testStore: ChessStore = {
        let white = Chess.PlaybackPlayer(firstName: "Test", lastName: "One",
                                         side: .white, moves: ["e2e4", ""], responseDelay: 0.1)
        let black = Chess.PlaybackPlayer(firstName: "Test", lastName: "Two",
                                         side: .black, moves: ["e7e5"], responseDelay: 0.1)

        let testGame = Chess.Game(white, against: black)
        let testState = ChessState(player: white, opponent: black)
        let store = ChessStore(initialState: testState,
                                       reducer: previewChessReducer, environment: ChessEnvironment(target: .development))
        store.state.game.board.resetBoard()
        return store
    }()
    static var previews: some View {
        GeometryReader { geometry in
            HStack {
                BoardView()
                    .environmentObject(testStore)
                    .frame(width: geometry.size.height, height: geometry.size.height, alignment: .center)
                Button("\(testStore.state.game.white.lastName ?? "Unknown") vs \(testStore.state.game.black.lastName ?? "Unknown")") {
                    testStore.state.game.start()
                }
            }
        }
    }
}
