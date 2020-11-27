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
    static func previewChessReducer(state: inout ChessState, action: ChessAction, environment: ChessEnvironment) -> AnyPublisher<ChessAction, Never>? {
        return nil
    }
    static var previewChessStore: ChessStore {
        let store = ChessStore(initialState: ChessState(),
                                       reducer: previewChessReducer, environment: ChessEnvironment(target: .development))
        store.state.game.board.resetBoard()
        return store
    }
}
