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
    static func previewChessReducer(state: inout ChessGame, action: ChessAction, environment: ChessEnvironment) -> AnyPublisher<ChessAction, Never>? {
        return nil
    }
    static var previewChessStore: ChessStore {
        let store = ChessStore(initialGame: ChessGame(),
                                       reducer: previewChessReducer, environment: ChessEnvironment(target: .development))
        store.game.board.resetBoard()
        return store
    }
}
