//
//  File.swift
//  
//
//  Created by Douglas Pedley on 11/26/20.
//

import Foundation
import SwiftUI
import Combine

typealias ChessGameReducer<Game, Action, Environment> =
    (inout Game, Action, Environment) -> AnyPublisher<Action, Never>?

extension ChessStore {
    static func chessReducer(
        game: inout Chess.Game,
        action: ChessAction,
        environment: ChessEnvironment
    ) -> AnyPublisher<ChessAction, Never>? {
        switch action {
        case .nextTurn:
            print("Next up... \(game.board.playingSide)")
            game.nextTurn()
        case .startGame:
            print("Starting...")
            game.start()
        case .setBoard(let fen):
            if fen==Chess.Board.startingFEN {
                print("Resetting board")
            } else {
                print("Board setup as: \(fen)")
            }
            game.board.resetBoard(FEN: fen)
        case .makeMove(let move):
            print("Moved: \(move.description)")
            game.execute(move: move)
        }
        return nil
    }
}
