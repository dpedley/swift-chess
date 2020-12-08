//
//  ChessReducer.swift
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
//            print("nextTurn: \(game.board.playingSide)")
            game.nextTurn()
        case .startGame:
//            print("startGame: Starting...")
            game.start()
        case .pauseGame:
//            print("pauseGame: Pausing...")
            game.userPaused = true
        case .setBoard(let fen):
//            print("setBoard: Board setup as: \(fen)")
            game.board.resetBoard(FEN: fen)
        case .makeMove(let move):
//            print("makeMove: \(move.side) \(move.description)")
            game.execute(move: move)
            if game.board.lastMove == move {
                game.changeSides(move.side.opposingSide)
            }
        }
        return nil
    }
}
