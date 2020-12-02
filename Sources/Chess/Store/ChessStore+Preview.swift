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
    static func previewChessReducer(state: inout Chess.Game, action: ChessAction, environment: ChessEnvironment) -> AnyPublisher<ChessAction, Never>? {
        return nil
    }
    static var previewChessStore: ChessStore {
        let store = ChessStore(initialGame: Chess.Game(),
                               reducer: ChessStore.chessReducer, environment: ChessEnvironment())
        store.game.board.resetBoard()
        return store
    }
}
