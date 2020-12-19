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
            mutableGame.pgn = Chess.Game.freshPGN(mutableGame.black, mutableGame.white)
            mutableGame.info = nil
            mutableGame.board.resetBoard(FEN: fen)
        case .resetBoard:
            Chess.log.info("resetBoard: resetting...")
            mutableGame.pgn = Chess.Game.freshPGN(mutableGame.black, mutableGame.white)
            mutableGame.info = nil
            mutableGame.board.resetBoard(FEN: Chess.Board.startingFEN)
        case .gameResult(let result, let status):
            Chess.log.info("gameResult: \(result.rawValue)")
            mutableGame.pgn.result = result
            mutableGame.info = .gameEnded(result: result, status: status)
            mutableGame.userPaused = true
        case .makeMove(let move):
            Chess.log.info("makeMove: \(move.side) \(move.description)")
            makeMove(move, game: &mutableGame)
        case .userTappedSquare(let position):
            Chess.log.info("userTappedSquare: \(position)")
            userTappedSquare(position, game: &mutableGame)
        case .userDragged(let position):
            Chess.log.info("userDragged: \(position)")
            // Clear before the drag starts in case they've also selected a square by tapping
            mutableGame.clearActivePlayerSelections()
            userTappedSquare(position, game: &mutableGame)
        case .userDropped(let position):
            Chess.log.info("userDropped: \(position)")
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
    static func userTappedSquare(_ position: Chess.Position, game: inout Chess.Game) {
        guard let human = (game.white as? Chess.HumanPlayer) ?? (game.black as? Chess.HumanPlayer) else {
            return
        }
        if game.userPaused {
            game.start()
        }
        guard let moveStart = human.initialPositionTapped else {
            // This was the first tap, setup the selection
            game.clearActivePlayerSelections()
            human.initialPositionTapped = position
            game.board.squares[position].selected = true
            if let targetedPositions =
                game.board.squares[position].buildMoveDestinations(board: game.board) {
                targetedPositions.forEach {
                    game.board.squares[$0].targetedBySelected = true
                }
            }
            return
        }
        // Check if they retapped the same square
        guard moveStart != position else {
            return
        }
        let move = Chess.Move(side: human.side, start: moveStart, end: position)
        human.moveAttempt = move
        game.clearActivePlayerSelections()
    }
}
