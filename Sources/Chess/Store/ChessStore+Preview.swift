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
        let store = ChessStore(initialGame: Chess.Game(),
                               reducer: ChessStore.chessReducer, environment: ChessEnvironment())
        store.game.board.resetBoard()
        return store
    }
}
