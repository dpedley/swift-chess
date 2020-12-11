//
//  ChessReducer.swift
//  
//
//  Created by Douglas Pedley on 11/26/20.
//

import Foundation
import SwiftUI
import Combine

public typealias ChessGameReducer = (Chess.Game, ChessAction, ChessEnvironment,
                                     PassthroughSubject<Chess.Game, Never>) -> Void

public extension ChessStore {
    static func chessReducer(
        game: Chess.Game,
        action: ChessAction,
        environment: ChessEnvironment,
        passThrough: PassthroughSubject<Chess.Game, Never>
    ) {
        var mutableGame = game
        switch action {
        case .nextTurn:
//            print("nextTurn: \(game.board.playingSide)")
            mutableGame.nextTurn()
        case .startGame:
//            print("startGame: Starting...")
            mutableGame.start()
        case .pauseGame:
//            print("pauseGame: Pausing...")
            mutableGame.userPaused = true
        case .setBoard(let fen):
//            print("setBoard: Board setup as: \(fen)")
            mutableGame.board.resetBoard(FEN: fen)
        case .makeMove(let move):
//            print("makeMove: \(move.side) \(move.description)")
            mutableGame.execute(move: move)
            if mutableGame.board.lastMove == move {
                mutableGame.changeSides(move.side.opposingSide)
            }
        }
        passThrough.send(mutableGame)
    }
}
