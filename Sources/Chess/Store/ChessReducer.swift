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
            Chess.log.info("nextTurn: \(game.board.playingSide)")
            mutableGame.nextTurn()
        case .startGame:
            Chess.log.info("startGame: Starting...")
            mutableGame.start()
        case .pauseGame:
            Chess.log.info("pauseGame: Pausing...")
            mutableGame.userPaused = true
        case .setBoard(let fen):
            Chess.log.info("setBoard: Board setup as: \(fen)")
            mutableGame.board.resetBoard(FEN: fen)
        case .resetBoard:
            Chess.log.info("resetBoard: resetting...")
            mutableGame.board.resetBoard(FEN: Chess.Board.startingFEN)
        case .makeMove(let move):
            Chess.log.info("makeMove: \(move.side) \(move.description)")
            mutableGame.execute(move: move)
            if mutableGame.board.lastMove == move {
                mutableGame.changeSides(move.side.opposingSide)
            }
        }
        passThrough.send(mutableGame)
    }
}
