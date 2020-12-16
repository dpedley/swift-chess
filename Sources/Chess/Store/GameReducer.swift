//
//  ChessReducer.swift
//  
//
//  Created by Douglas Pedley on 11/26/20.
//

import Foundation
import SwiftUI
import Combine

public typealias ChessGameReducer = (Chess.Game, Chess.GameAction, ChessEnvironment,
                                     PassthroughSubject<Chess.Game, Never>) -> Void
public extension ChessStore {
    static func gameReducer(
        game: Chess.Game,
        action: Chess.GameAction,
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
            makeMove(move, game: &mutableGame)
        case .userTappedSquare(let position):
            Chess.log.info("userTappedSquare: \(position)")
            userTappedSquare(position, game: &mutableGame)
        }
        passThrough.send(mutableGame)
    }
    private static func makeMove(_ move: Chess.Move, game: inout Chess.Game) {
        game.execute(move: move)
        if game.board.lastMove == move {
            game.changeSides(move.side.opposingSide)
        }
    }
    private static func userTappedSquare(_ position: Chess.Position, game: inout Chess.Game) {
        game.board.squares[position].selected.toggle()
        if game.board.squares[position].selected {
            if let targetedPositions =
                game.board.squares[position].buildMoveDestinations(board: game.board) {
                targetedPositions.forEach {
                    game.board.squares[$0].targetedBySelected = true
                }
            }
        } else {
            for idx in 0..<64 {
                game.board.squares[idx].targetedBySelected = false
            }
        }
    }
}
