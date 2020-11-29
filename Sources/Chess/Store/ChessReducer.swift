//
//  File.swift
//  
//
//  Created by Douglas Pedley on 11/26/20.
//

import Foundation
import SwiftUI
import Combine

typealias ChessStateReducer<State, Action, Environment> =
    (inout State, Action, Environment) -> AnyPublisher<Action, Never>?

extension App {
    static func chessReducer(
        state: inout ChessState,
        action: ChessAction,
        environment: ChessEnvironment
    ) -> AnyPublisher<ChessAction, Never>? {
        switch action {
        case .startGame:
            print("start game")
        case .setBoard(fen: let fen):
            print("set board with fen \(fen)")
            state.game.board.resetBoard(FEN: fen)
        }
        return nil
    }
}
