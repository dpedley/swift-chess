//
//  File.swift
//  
//
//  Created by Douglas Pedley on 11/26/20.
//

import Foundation
import SwiftUI
import Combine

extension PreviewProvider {
    static var previewChessStore: ChessStore {
        let store = ChessStore(game: Chess.Game(),
                               reducer: ChessStore.chessReducer, environment: ChessEnvironment())
        store.game.board.resetBoard()
        return store
    }
}

struct ChessStorePreview: PreviewProvider {
    static let fen = "5r1k/pp5p/6P1/2p1P3/6Q1/1P1Pq3/P1P3PP/5R1K b - - 0 26"
    static var store: ChessStore = {
        let white = Chess.HumanPlayer(side: .white)
        let black = Chess.HumanPlayer(side: .black)
        var game = Chess.Game(white, against: black)
        game.board.resetBoard(FEN: fen)
        let store = ChessStore(game: game)
        store.game.userPaused = true
        return store
    }()
    static var previews: some View {
        HStack {
            BoardView()
                .environmentObject(store)
            Button(store.game.board.FEN == fen ? "Black to Mate" : "Reset") {
                if store.game.board.FEN == fen {
                    store.send(.makeMove(move: Chess.Move.black.f8.f1))
                } else {
                    store.send(.setBoard(fen: fen))
                }
            }
        }
    }
}
